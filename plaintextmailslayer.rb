require 'rubygems'
require 'bundler'
Bundler.require

require 'yaml'

$config = YAML::load_file 'config.yml'

Mail.defaults do
  delivery_method :smtp, { :address              => $config['smtp']['host'],
                           :port                 => $config['smtp']['port'],
                           :domain               => $config['smtp']['domain'],
                           :user_name            => $config['smtp']['username'],
                           :password             => $config['smtp']['password'],
                           :authentication       => :login,
                           :enable_starttls_auto => true  }
end

class PlainTextMailSlayer < MiniSmtpServer
  def new_message_event(message)
    classify Mail.read_from_string message[:data]
  end

  private

  def classify(mail)
    if $config['encrypted_mails']['recipients'].include? mail.to.first.strip
      encrypted_passing mail
    else
      plain_passing mail
    end
  end

  def encrypted_passing(mail)
    encrypted_body = if mail.multipart?
                       mail.parts.delete_if {|part| !(part.content_type.start_with? 'text/plain')}
                       encrypt_message mail.parts.first.body.to_s, mail.to
                     else
                       encrypt_message mail.body.decoded.to_s, mail.to
                     end
    subject = $config['encrypted_mails']['subject_overwrite'] ||= mail.subject

    outgoing = Mail.new do
      from mail.from
      to mail.to
      subject subject
      body encrypted_body
    end
    outgoing.deliver
  end

  def plain_passing(mail)
    mail.deliver
  end

  def encrypt_message(body, recipient)
    crypto = GPGME::Crypto.new :armor => true
    crypto.encrypt(body.to_s, :recipients => recipient, :always_trust => true).to_s
  end
end
