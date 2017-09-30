require 'vk_message'
class OtherBuy < ActiveRecord::Base

  def self.first_url
    "other_buy"
  end

  def notify_buy(cashbox=nil)
    if cashbox.present?
      message = "#{title} на #{price.to_i} рублей\nКасса: #{cashbox.curr_cash} рублей"
      VkMessage.run(message) if Rails.env.production?
    end
  end

  def self.took_sum
    where(type_mode: false).sum(:price)
  end

  def self.it_sum
    where(type_mode: true).sum(:price)
  end

  def self.curr_month_price(type_mode=true)
    start_day = (Time.now - Time.new.day.day + 1.day).beginning_of_day
    all_others = where(["created_at > ?", start_day])
    all_others.where(type_mode: type_mode).sum(:price)
  end
end
