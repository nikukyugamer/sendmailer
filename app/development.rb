require File.expand_path('../../sendmailer', __FILE__)
require File.expand_path('../../lib/yahoo_twitter_hot_ranking', __FILE__)

obj = SendMailer.new

this_app_from           = 'foo@bar'
this_app_address_group  = 'development'
this_app_subject        = 'this is sample subject'
this_app_body           =
  <<~EOM
    Hello,
    World!
    Hello,
    Ruby!
  EOM
attachment_file         = [File.expand_path('../../attachment/foobar.png', __FILE__)] # ['file_01.png', 'file_02.png']

obj.send_mail(from: this_app_from, address_group: this_app_address_group, subject: this_app_subject, body: this_app_body, attachment_file: attachment_file)
