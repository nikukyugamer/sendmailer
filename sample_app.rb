require './sendmailer'

obj = SendMailer.new

this_app_from           = 'foo@bar'
this_app_address_group  = 'development'
this_app_subject        = 'this is sample subject'
this_app_body           =
  <<~EOM
    hello
    World!
    hello
    Ruby!
  EOM

obj.send_mail(from: this_app_from, address_group: this_app_address_group, subject: this_app_subject, body: this_app_body)
