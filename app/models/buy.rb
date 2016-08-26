require 'vk_message'
class Buy < ActiveRecord::Base
  has_many :buy_items
  default_scope { order("created_at DESC") }

  def self.all_sum
    sum(:price)
  end

  def notify_buy
    message = "Закуп: #{self.price.to_i} рублей\nКасса: #{Sale.cash_box} рублей"
    VkMessage.run(message)
  end

  def self.curr_month_price
    start_day = (Time.now - Time.new.day.day + 1.day).beginning_of_day
    where(["created_at > ?", start_day]).sum(:price)
  end

end
