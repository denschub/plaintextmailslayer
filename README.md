PlainTextMailSlayer
===================

The PlainTextMailSlayer is a little application used to 'proxy' mails to encrypt
them using OpenPGP. It allows you to send encrypted mails from application which
do not support sending encrypted mails.

PlainTextMailSlayer was created to handle some edge cases and I am sharing the
source in the case somebody needs it. Don't expect too much. However, I will
accept pull requests if you want to improve it.

Installation
------------

A simple

    bundle install

should install all the dependencies. In addition, you have to create a
```config.yml``` file. A template can be found in ```config.yml.example```, the
keys should be self-explanatory.

One note: If you set encrypted_mails.subject_overwrite, all subjects from
encrypted mails will get replaced by that to make sure no private data is
exposed unencrypted. Leave it empty to use the original subjects.

Key and address management
--------------------------

You can manage your keys using the gpg cli interface. Make sure you import the
keys with the same user that will run PlainTextMailSlayer or it won't be able
to find the keys.

In addition, you have to add all recipients of encrypted mails to the config
file. Addresses not listed in the config file will not get encrypted mails,
regardless if there is a key available or not.

Usage
-----

To start, run

    foreman start

and the application will spawn an SMTP server listening at localhost:2525. Set
up the applications sending unencrypted mails to send mails to localhost:2525.
PlainTextMailSlayer will take care of all mails that are coming in, so make
sure it is not accessible from outside, there is no authentication enabled.
