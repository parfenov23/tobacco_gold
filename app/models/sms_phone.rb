class SmsPhone < ActiveRecord::Base
  require "sms_gateway"
  require 'vk_message'
  require 'pusher_io'

  belongs_to :magazine

  def self.all_sms
    SmsGateway.messages
  end

  def self.find_number_received_sms(number)
    SmsGateway.messages('', "received", number)
  end

  def self.parse_hash_sms(number="")
    sms_all = number.blank? ? all_sms : find_number_received_sms(number)
    result_sms = []
    sms_all.each{ |sms| result_sms << params_to_hash_sms(sms) }
    result_sms
  end

  def self.create_new_sms(magazine_id, sms_hash = {})
    find_sms = where(id_sms: sms_hash[:id_sms]).last || where(body: sms_hash[:body]).last
    if find_sms.blank? && sms_hash[:address] == "900"
      sms = create(sms_hash.merge({magazine_id: magazine_id}))
      if sms.type_sms != "отправьте код"
        sms.type_sms == "покупка" ? sms.pay_to_other_by("down") : sms.notify_sms
      else
        SmsPhoneTask.create(phone: sms_hash[:address], body: sms_hash[:sum], magazine_id: magazine_id, sms_id: Time.now.to_i.to_s)
      end
    end
  end

  def self.params_to_hash_sms(sms)
    sum = match_body_sms(sms["body"]).to_s.gsub(/(списание|покупка|зачисление|отправьте код) /, '').gsub("р", "").to_i
    {id_sms: sms["id"].scan(/[0-9]+/).join.to_i, body: sms["body"], sum: sum, date_time: sms["created_at"], address: sms["number"]}
  end

  def self.match_body_sms(body)
    regexp = Regexp.new(/(списание|покупка|зачисление|отправьте код)[+-]?([0-9]*[.])? [0-9]+(р| )/)
    body.match(regexp)
  end

  def type_sms
    type = SmsPhone.match_body_sms(body)
    type.present? ? type[1] : "прочее"
  end

  def notify_sms
    rub_title = Russian.p(sum, "рубль", "рубля", "рублей")
    message = "VISA SMS INFO: #{type_sms} #{sum.to_i} #{rub_title}\n"

    PusherIo.sender("enlistment", "sms_info", {message: message, sum: sum.to_i, magazine_id: magazine_id}) if type_sms == "зачисление"
    VkMessage.run(message, "user", {access_token: magazine.vk_api_key_user, chat_id: magazine.vk_chat_id}) if sum > 0
  end

  def clear_body
    r = Regexp.new(/VISA[0-9]+ /)
    body.gsub(r, '').gsub('Сбербанк Онлайн.', '')
  end

  def self.first_url
    "sms"
  end

  def pay_to_other_by(type_mode)
    params_model = {title: clear_body, price: sum, type_mode: (type_mode == "up"), magazine_id: magazine.id}
    other_buy = OtherBuy.create(params_model)
    magazine.cashbox.calculation('visa', other_buy.price, other_buy.type_mode)
    update(archive: true)
    self
  end
end
