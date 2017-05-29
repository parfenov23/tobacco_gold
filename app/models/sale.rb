require 'vk_message'
class Sale < ActiveRecord::Base
  has_many :sale_items, dependent: :destroy
  belongs_to :user
  belongs_to :contact
  default_scope { order("created_at DESC") }

  def notify_buy
    message = "Продажа: #{self.price.to_i} рублей\n Информация: #{sale_url}\nКасса: #{Sale.cash_box} рублей"
    VkMessage.run(message)
  end

  def self.cash_box
    sum(:price) + OtherBuy.it_sum - OtherBuy.took_sum - Buy.all_sum - ManagerPayment.sum(:price)
  end

  def self.last_sales_price
    where(["created_at > ?", Time.now - 7.day]).sum(:price)
  end

  def self.sales_profit
    where(["created_at > ?", Time.now - 7.day]).sum(:profit)
  end

  def self.current_month_profit
    where(["created_at > ?", Time.now.beginning_of_month]).sum(:profit)
  end

  def sale_url
    "http://tobacco-gold.tk/admin/sales/#{id}/info"
  end

  def self.curr_year_statistic
    arr_result = []
    Time.now.month.times do |i|
      month = Time.now.beginning_of_year + i.month
      first_day = month.beginning_of_month
      last_day = month.end_of_month
      all_sales = Sale.where(["created_at > ?", first_day]).where(["created_at < ?", last_day])
      sales_sum = all_sales.sum(:price)
      profit_sum = all_sales.sum(:profit)
      arr_result << [Russian::strftime(month, "%B"), sales_sum, profit_sum]
    end
    arr_result
  end
  
  def self.curr_month_price
    start_day = (Time.now - Time.new.day.day + 1.day).beginning_of_day
    where(["created_at > ?", start_day]).sum(:price)
  end
end
