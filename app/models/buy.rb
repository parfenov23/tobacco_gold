require 'vk_message'
class Buy < ActiveRecord::Base
  has_many :buy_items
  belongs_to :provider
  belongs_to :magazine
  default_scope { order("created_at DESC") }

  def self.all_sum
    where(def_pay: true).sum(:price)
  end

  def notify_buy(cashbox=magazine.cashbox)
    message = "Закуп: #{self.price.to_i} рублей\nКасса: #{cashbox.curr_cash} рублей"
    VkMessage.run(message, "user", {access_token: magazine.api_key}) if Rails.env.production?
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

  def self.curr_year_price(type="year")
    start_day = type == "year" ? Time.now.beginning_of_year : (Time.now - 1.year).beginning_of_year
    end_day = type == "last_year" ? Time.now.beginning_of_year : Time.now
    where(["created_at > ?", start_day]).where(["created_at <= ?", end_day]).sum(:price)
  end

  def self.tester
    p "teeeees"
  end

end
