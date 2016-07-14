class Buy < ActiveRecord::Base
  has_many :buy_items

  def self.all_sum
    sum(:price)
  end

  def notify_buy
    message = "Закуп: #{self.price.to_i} рублей\nКасса: #{Sale.cash_box} рублей"
    chat_id = "53"
    auth_key = "9b7dba694b2f38cb8d080c35625e2d7a559b00cd5c73167f782ca02ff07799691a0dbd1fbafbfb686448c"
    Mechanize.new.get("https://api.vk.com/method/messages.send?chat_id=#{chat_id}&message=#{message}&access_token=#{auth_key}")
  end

end
