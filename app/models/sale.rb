require 'vk_message'
class Sale < ActiveRecord::Base
  has_many :sale_items, dependent: :destroy
  belongs_to :user
  belongs_to :contact
  belongs_to :magazine
  default_scope { order("created_at DESC") }

  def notify_buy(cashbox=magazine.cashbox)
    message = "Продажа: #{self.price.to_i} рублей\nИнформация: #{sale_url}\n ===== Касса =====\nНаличные: #{cashbox.cash} рублей\nVisa: #{cashbox.visa}"
    VkMessage.run(message, "user", {access_token: magazine.vk_api_key_user, chat_id: magazine.vk_chat_id}) if (Rails.env.production? && magazine.vk_api_key_user.present?)
  end

  def find_profit
    result_profit = 0
    sale_items.each do |sale_item|
      item = sale_item.product_item
      product = item.product
      price = sale_item.product_price
      if price.present?
        last_buy_price = (item.last_buy_price rescue 0)
        result_profit += (price.price - last_buy_price)*sale_item.count.to_i if last_buy_price > 0
      end
    end
    result_profit
  end

  def self.cash_box
    sum(:price) + OtherBuy.it_sum - OtherBuy.took_sum - Buy.all_sum - ManagerPayment.where(payment: true).sum(:price)
  end

  def close
    magazine.cashbox.calculation(visa ? "visa" : "cash" , price, false)
    sale_items.each do |sale_item|
      current_count = sale_item.product_item.product_item_counts.where(magazine_id: magazine_id).last
      current_count.update(count: current_count.count + sale_item.count)
    end
    update(in_stock: true)
  end

  def self.current_day
    where(["created_at > ? ", Time.current.beginning_of_day]).where(["created_at < ? ", Time.current.end_of_day])
  end

  def self.curr_year(type="year")
    time_start = type == "year" ? Time.now.beginning_of_year : (Time.now - 1.year).beginning_of_year
    time_end = type == "year" ? Time.current.end_of_year : Time.now.beginning_of_year
    where(["created_at > ? ", time_start]).where(["created_at < ? ", time_end])
  end

  def self.last_sales_price
    where(["created_at > ?", Time.now - 7.day]).sum(:price)
  end

  def self.sales_profit
    where(["created_at > ?", Time.now - 7.day]).sum(:profit)
  end

  def self.current_day_profit
    current_day.sum(:profit)
  end

  def self.current_month_profit
    where(["created_at > ?", Time.now.beginning_of_month]).sum(:profit)
  end

  def self.current_year_profit(type="year")
    time_start = type == "year" ? Time.now.beginning_of_year : (Time.now - 1.year).beginning_of_year
    time_end = type == "year" ? Time.current.end_of_year : Time.now.beginning_of_year
    where(["created_at > ?", time_start]).where(["created_at < ? ", time_end]).sum(:profit)
  end

  def sale_url
    "http://hookah-stock.ru/admin/sales/#{id}/info"
  end

  def self.curr_year_statistic(magaz_id=nil, type="current")
    arr_result = []
    curr_year = type == "current" ? Time.now : (Time.now - 1.year).end_of_year
    curr_year.month.times do |i|
      month = curr_year.beginning_of_year + i.month
      first_day = month.beginning_of_month
      last_day = month.end_of_month
      all_sales = find_model_result(self, first_day, last_day)

      other_buy_all_year = find_model_result(OtherBuy.where(magazine_id: magaz_id), first_day, last_day)
      all_other_buy = other_buy_all_year.where(type_mode: false).sum(:price)
      all_other_buy += find_model_result(ManagerPayment.where(magazine_id: magaz_id), first_day, last_day).where(payment: true).sum(:price)
      all_other_buy_up = other_buy_all_year.where(type_mode: true).sum(:price)

      sales_sum = all_sales.sum(:price)
      profit_sum = all_sales.sum(:profit) + all_other_buy_up

      arr_result << [Russian::strftime(month, "%B"), sales_sum, profit_sum, all_other_buy]
    end
    arr_result
  end

  def self.curr_month_statistic(magaz_id=nil)
    arr_result = []
    Time.now.day.times do |i|
      day = Time.now.beginning_of_month + i.day
      first_day = day.beginning_of_day
      last_day = day.end_of_day
      all_sales = find_model_result(self, first_day, last_day)

      other_buy_all_month = find_model_result(OtherBuy.where(magazine_id: magaz_id), first_day, last_day)
      all_other_buy = other_buy_all_month.where(type_mode: false).sum(:price)
      all_other_buy += find_model_result(ManagerPayment.where(magazine_id: magaz_id), first_day, last_day).where(payment: true).sum(:price)
      all_other_buy_up = other_buy_all_month.where(type_mode: true).sum(:price)

      sales_sum = all_sales.sum(:price)
      profit_sum = all_sales.sum(:profit) + all_other_buy_up
      arr_result << [Russian::strftime(day, "%a, %d"), sales_sum , profit_sum, all_other_buy]
    end
    arr_result
  end

  def self.meneger_curr_year_statistic(manager_id)
    arr_result = []
    Time.now.month.times do |i|
      month = Time.now.beginning_of_year + i.month
      first_day = month.beginning_of_month
      last_day = month.end_of_month
      all_sales = find_model_result(Sale.where(user_id: manager_id), first_day, last_day)
      sales_sum = all_sales.sum(:price)
      all_earnings = find_model_result(ManagerPayment.where(user_id: manager_id), first_day, last_day).sum(:price)

      arr_result << [Russian::strftime(month, "%B"), sales_sum, all_earnings]
    end
    arr_result
  end

  def self.meneger_curr_month_statistic(manager_id)
    arr_result = []
    Time.now.day.times do |i|
      day = Time.now.beginning_of_month + i.day
      first_day = day.beginning_of_day
      last_day = day.end_of_day
      all_sales = find_model_result(Sale.where(user_id: manager_id), first_day, last_day)
      sales_sum = all_sales.sum(:price)
      all_earnings = find_model_result(ManagerPayment.where(user_id: manager_id), first_day, last_day).sum(:price)

      arr_result << [Russian::strftime(day, "%a, %d"), sales_sum, all_earnings]
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

  def company_id
    magazine.company_id
  end
end
