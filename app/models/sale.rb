require 'vk_message'
class Sale < ActiveRecord::Base
  has_many :sale_items, dependent: :destroy
  default_scope { order("created_at DESC") }

  def notify_buy
    message = "Продажа: #{self.price.to_i} рублей\n Информация: #{sale_url}\nКасса: #{Sale.cash_box} рублей"
    VkMessage.run(message)
  end

  def self.cash_box
    sum(:price) + OtherBuy.it_sum - OtherBuy.took_sum - Buy.all_sum
  end

  def self.last_sales_price
    where(["created_at > ?", Time.now - 7.day]).sum(:price)
  end

  def self.sales_profit
    price_sales = 0
    where(["created_at > ?", Time.now - 7.day]).each do |sale|
      sale.sale_items.each do |sale_item|
        price_sales += (sale_item.product_item.product.min_price * sale_item.count)
      end
    end
    price_sales
  end

  def sale_url
    "http://tobacc-gold.tk/admin/sales/#{id}/info"
  end
  
  def self.curr_month_price
    start_day = (Time.now - Time.new.day.day + 1.day).beginning_of_day
    where(["created_at > ?", start_day]).sum(:price)
  end
end
