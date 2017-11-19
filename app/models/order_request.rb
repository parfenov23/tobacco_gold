require 'vk_message'
class OrderRequest < ActiveRecord::Base
  belongs_to :user
  belongs_to :contact
  # serialize :basket, ActiveRecord::Coders::NestedHstore

  def title
    "Заявка №#{id} от #{created_at.strftime('%d.%m.%y')}"
  end

  def total_sum
    sum = 0
    items.map {|k, v| sum += (ProductItem.find(k).product.current_price * v.to_i) }
    sum
  end

  def paid(user_id=nil, contact_id=nil)
    sale = Sale.create(user_id: user_id, contact_id: contact_id)
    result = 0
    curr_user = User.find(user_id)
    items.each do |id, count|
      item = ProductItem.find(id)
      product = item.product
      price = product.current_price_model
      result += price.price.to_i*count.to_i
      item.update({count: (item.count - count.to_i)})
      SaleItem.create({sale_id: sale.id, product_item_id: item.id, count: count.to_i, product_price_id: price.id})
    end
    sale.update(price: result, profit: sale.find_profit, magazine_id: curr_user.magazine_id)
    sale.notify_buy
  end

  def price
    result = 0
    items.each do |id, count|
      item = ProductItem.find(id)
      product = item.product
      price = product.current_price_model
      result += price.price.to_i*count.to_i
    end
    result
  end


  def notify
    message = "Клиент оставил заявку на сайте\nНомер: #{id}\nСумма: #{total_sum} рублей"
    VkMessage.run(message)
  end

  def self.first_url
    "order_requests"
  end
end
