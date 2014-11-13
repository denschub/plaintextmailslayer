require_relative 'plaintextmailslayer'

desc 'server'
task :server do
  server = PlainTextMailSlayer.new(2525, "127.0.0.1", 10)
  server.start
  server.join
end
