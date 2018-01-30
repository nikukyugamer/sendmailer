class SendMailer
  require 'mail'
  require 'yaml'

  MAIL_SERVER_CONFIG  = 'config/mail_server.yml'.freeze
  ADDRESS_BOOK_FILE   = 'config/address_book.yml'.freeze

  def initialize
    @server = {
      address: mail_server['smtp_address'],
      port: mail_server['port'],
      domain: mail_server['domain'],
      user_name: mail_server['user_name'],
      password: mail_server['password'],
      authentication: mail_server['authentication'],
      enable_starttls_auto: mail_server['enable_starttls_auto'],
    }
  end

  def mail_server
    YAML.load_file(MAIL_SERVER_CONFIG)
  end

  def to_address(address_group)
    YAML.load_file(ADDRESS_BOOK_FILE)[address_group].join(", ")
  end

  def send_mail(from:, address_group:, subject: '', body: '', attachment_file: [])
    mail = Mail.new
    mail.charset  = 'UTF-8'
    mail.delivery_method(:smtp, @server)

    mail.from     = from
    mail.to       = to_address(address_group)
    mail.subject  = subject
    mail.body     = body

    unless attachment_file.empty?
      attachment_file.each do |file|
        mail.add_file(file)
      end
    end

    mail.deliver
  end
end
