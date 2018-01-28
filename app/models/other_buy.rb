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

  def self.curr_day_price(type_mode=true)
    start_day = Time.now.beginning_of_day
    where(["created_at > ?", start_day]).where(type_mode: type_mode).sum(:price)
  end

  def self.curr_year_price(type_mode=true, type="year")
    start_day = type == "year" ? Time.now.beginning_of_year : (Time.now - 1.year).beginning_of_year
    end_day = type == "last_year" ? Time.now.beginning_of_year : Time.now
    where(["created_at > ?", start_day]).where(["created_at <= ?", end_day]).where(type_mode: type_mode).sum(:price)
  end
end
