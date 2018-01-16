require 'vk_message'
class Buy < ActiveRecord::Base
  has_many :buy_items
  belongs_to :provider
  default_scope { order("created_at DESC") }

  def self.all_sum
    where(def_pay: true).sum(:price)
  end

  def notify_buy(cashbox=nil)
    if cashbox.present?
      message = "Закуп: #{self.price.to_i} рублей\nКасса: #{cashbox.curr_cash} рублей"
      VkMessage.run(message) if Rails.env.production?
    end
  end

  def provider_title
    provider.present? ? provider.title : "Нет поставщика"
  end

  def self.curr_month_price
    start_day = (Time.now - Time.new.day.day + 1.day).beginning_of_day
    where(["created_at > ?", start_day]).sum(:price)
  end

  def self.curr_day_price
    start_day = Time.now.beginning_of_day
    where(["created_at > ?", start_day]).sum(:price)
  end

  def self.curr_year_price
    start_day = Time.now.beginning_of_year
    where(["created_at > ?", start_day]).sum(:price)
  end

  def self.tester
    p "teeeees"
  end

end
