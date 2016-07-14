class OtherBuy < ActiveRecord::Base

  def notify_buy
    message = "#{title} на #{price.to_i} рублей\nКасса: #{Sale.cash_box} рублей"
    chat_id = "53"
    auth_key = "9b7dba694b2f38cb8d080c35625e2d7a559b00cd5c73167f782ca02ff07799691a0dbd1fbafbfb686448c"
    Mechanize.new.get("https://api.vk.com/method/messages.send?chat_id=#{chat_id}&message=#{message}&access_token=#{auth_key}")
  end

  def self.took_sum
    where(type_mode: false).sum(:price)
  end

  def self.it_sum
    where(type_mode: true).sum(:price)
  end
end
