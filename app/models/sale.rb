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

  def find_profit
    result_profit = 0
    sale_items.each do |sale_item|
      item = sale_item.product_item
      product = item.product
      price = sale_item.product_price
      last_buy_price = (item.buy_items.last.price rescue 0)
      result_profit += (price.price - last_buy_price)*sale_item.count.to_i if last_buy_price > 0
    end
    result_profit
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
      all_sales = find_model_result(Sale, first_day, last_day)
      all_other_buy = find_model_result(OtherBuy, first_day, last_day).sum(:price)
      all_other_buy += find_model_result(ManagerPayment, first_day, last_day).sum(:price)
      sales_sum = all_sales.sum(:price)
      profit_sum = all_sales.sum(:profit)
      arr_result << [Russian::strftime(month, "%B"), sales_sum, profit_sum, all_other_buy]
    end
    arr_result
  end

  def self.find_model_result(model, first_day, last_day)
    model.where(["created_at > ?", first_day]).where(["created_at < ?", last_day])
  end

  def self.curr_month_price
    start_day = (Time.now - Time.new.day.day + 1.day).beginning_of_day
    where(["created_at > ?", start_day]).sum(:price)
  end
end
