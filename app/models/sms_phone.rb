class SmsPhone < ActiveRecord::Base
  require "sms_gateway"
  require 'vk_message'

  def self.all_sms
    SmsGateway.messages
  end

  def self.find_number_received_sms(number)
    SmsGateway.messages('', "received", number)
  end

  def self.parse_hash_sms(number="")
    sms_all = number.blank? ? all_sms : find_number_received_sms(number)
    result_sms = []
    sms_all.each do |sms|
      sum = match_body_sms(sms["message"]).to_s.gsub(/(списание|покупка|зачисление) /, '').gsub("р", "").to_i
      result_sms << {id_sms: sms["id"].to_i, body: sms["message"], sum: sum, date_time: sms["created_at"], address: sms["contact"]["number"]}
    end
    result_sms
  end

  def self.create_new_sms
    parse_hash_sms("900").each do |sms_hash|
      find_sms = where(id_sms: sms_hash[:id_sms]).last
      if find_sms.blank?
        sms = create(sms_hash)
        sms.notify_sms
      end
    end
  end

  def self.match_body_sms(body)
    regexp = Regexp.new(/(списание|покупка|зачисление) [0-9]+р/)
    body.match(regexp)
  end

  def notify_sms
    if sum > 0
      rub_title = Russian.p(sum, "рубль", "рубля", "рублей")
      type = SmsPhone.match_body_sms(body)[1]
      message = "VISA SMS INFO: #{type} #{self.sum.to_i} #{rub_title}\n"
      VkMessage.run(message)
    end
  end

  def clear_body
    r = Regexp.new(/VISA[0-9]+ /)
    body.gsub(r, '').gsub('Сбербанк Онлайн.', '')
  end

  def self.first_url
    "sms"
  end
end
