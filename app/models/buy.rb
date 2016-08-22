require 'vk_message'
class Buy < ActiveRecord::Base
  has_many :buy_items

  def self.all_sum
    sum(:price)
  end

  def notify_buy
    message = "Закуп: #{self.price.to_i} рублей\nКасса: #{Sale.cash_box} рублей"
    VkMessage.run(message)
  end

end
