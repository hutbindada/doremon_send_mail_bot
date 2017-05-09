require 'telegram_bot'
require 'pp'
require 'logger'
require 'net/smtp'
require './common.rb'
require 'yaml'

APP_CONFIG = YAML::load_file(File.join(__dir__, 'config/config.yml'))
logger = Logger.new(STDOUT, Logger::DEBUG)
bot = TelegramBot.new(token: '248910231:AAFRry9Gca1rRRbYZFLRrujqt2u3msZtspo', logger: logger)
logger.debug "starting telegram bot"
help_user = "Gửi mail cho telegram bot theo định dạng email/ten_nguoi_nhan/gioi_tinh(nam/nu)
Ví dụ: example@mail.com/Nguyen Van A/nam"
bot.get_updates(fail_silently: true) do |message|
  logger.info "@#{message.from.username}: #{message.text}"
  command = message.get_command_for(bot)

  message.reply do |reply|
    # p "abc = #{A.abc}"
    check = command.split('/')
    if check.count==3
      mail = check[0]
      name = check[1]
      gender = check[2]
      if check[2]=='nam'
        gender="anh"
      else
        gender='chị'
      end
message_body = <<MESSAGE_END
From: Hai Vuzaco
To: #{mail}
Subject: Khách hàng của bạn

Chào #{gender} #{name},

Em tên Hải. Lời đầu tiên em chúc #{gender} một ngày làm việc có hiệu quả.
Được biết #{gender} đang có nhu cầu tìm kiếm những khách hàng quan tâm đến căn hộ #{gender} đang bán.

Em rất vui khi được giới thiệu dịch vụ CUNG CẤP KHÁCH HÀNG TIỀM NĂNG bên công ty em : cung cấp tên, số điện thoại, email của những khách hàng quan tâm đến sản phẩm của #{gender}. Có nghĩa là dịch vụ chỉ tính chi phí khi khách hàng thật sự quan tâm đến sản phẩm bên #{gender}.

Nếu #{gender} quan tâm có thể liên hệ trực tiếp với em qua email này hoặc số điện thoại: 0938 452 634 .

Trân trọng,
Lương Thị Hải
MESSAGE_END

        smtp = Net::SMTP.new 'smtp.gmail.com', 587
        smtp.enable_starttls
        smtp.start('vuzaco.vn', APP_CONFIG['staging']['email'], APP_CONFIG['staging']['password'], :login) do
          smtp.send_message(message_body, APP_CONFIG['staging']['email'], mail)
        end
        
    else
      reply.text = "Sai định dạng. "+help_user
    end
    
    logger.info "sending #{reply.text.inspect} to @#{message.from.username}"
    reply.send_with(bot)
  end
end
