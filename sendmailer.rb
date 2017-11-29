class Sendmailer
  require 'yaml'
  require 'mail'
  require 'net/http'
  require 'json'
  require 'erb'
  require 'date'
  require 'time'
  require 'pp'

  ADDRESS_FILE        = 'address.yml'.freeze
  TO_ADDRESS_GROUP    = 'development'.freeze
  ATTACHMENT_FILENAME = 'my_image.jpg'.freeze
  ERB_MAIL_CONTENT    = 'my_content.erb'.freeze

  def initialize
    @mail_server     = YAML.load_file('config/mail_server.yml')
    @to_address      = YAML.load_file("config/address/#{ADDRESS_FILE}")[TO_ADDRESS_GROUP].join(', ')
    @attachment_file = "attachment_file/#{ATTACHMENT_FILENAME}"
  end

  def options
    {
      address: @mail_server['sender']['smtp_address'],
      port: @mail_server['sender']['port'],
      domain: @mail_server['sender']['domain'],
      user_name: @mail_server['sender']['user_name'],
      password: @mail_server['sender']['password'],
      authentication: @mail_server['sender']['authentication'],
      enable_starttls_auto: @mail_server['sender']['enable_starttls_auto'],
    }
  end

  def mail_body
    file_content = File.open(MAIL_CONTENT) do |file|
      file.read
    end
    mail_bopdy_erb = ERB.new(file_content)
    mail_body_erb.result(binding)
  end

  def mail
    Mail.new do
      from      'from_name@example.com' # TODO: ここは外に出す
      to        @to_address
      subject   'Hello, Mailer!' # TODO: ここは外に出す
      body      mail_content
      add_file  filename: "#{ATTACHMENT_FILENAME}", content: File.read(@attachment_file)
    end
  end

  def sendmail(mail)
    mail.delivery_method :smtp, @options
    mail.charset = 'UTF-8'
    mail.deliver
  end
end
