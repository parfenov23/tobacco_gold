class Sale < ActiveRecord::Base
  has_many :sale_items, dependent: :destroy

  def notify_buy
    message = "Продажа: #{self.price.to_i} рублей\nКасса: #{Sale.cash_box} рублей"
    chat_id = "53"
    auth_key = "e1cc23af2d7c44bcb851c1ae82152a0db5816c98f03218db5e2d8f27a75aeb6f14d98dbe2d75fc4eab7f4"
    Mechanize.new.get("https://api.vk.com/method/messages.send?chat_id=#{chat_id}&message=#{message}&access_token=#{auth_key}")
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
end
