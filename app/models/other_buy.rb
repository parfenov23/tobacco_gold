require 'vk_message'
class OtherBuy < ActiveRecord::Base

  def notify_buy
    message = "#{title} на #{price.to_i} рублей\nКасса: #{Sale.cash_box} рублей"
    VkMessage.run(message)
  end

  def self.took_sum
    where(type_mode: false).sum(:price)
  end

  def self.it_sum
    where(type_mode: true).sum(:price)
  end
end
