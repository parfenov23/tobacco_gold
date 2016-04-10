class OtherBuy < ActiveRecord::Base

  def notify_buy
    message = "#{title} на #{price.to_i} рублей\nКасса: #{Sale.cash_box} рублей"
    chat_id = "54"
    auth_key = "e1cc23af2d7c44bcb851c1ae82152a0db5816c98f03218db5e2d8f27a75aeb6f14d98dbe2d75fc4eab7f4"
    Mechanize.new.get("https://api.vk.com/method/messages.send?chat_id=#{chat_id}&message=#{message}&access_token=#{auth_key}")
  end

  def self.took_sum
    where(type_mode: false).sum(:price)
  end

  def self.it_sum
    where(type_mode: true).sum(:price)
  end
end
