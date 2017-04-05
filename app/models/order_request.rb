require 'vk_message'
class OrderRequest < ActiveRecord::Base
  belongs_to :user
  # serialize :basket, ActiveRecord::Coders::NestedHstore

  def title
    "Заявка №#{id} от #{created_at.strftime('%d.%m.%y')}"
  end

  def total_sum
    sum = 0
    items.map {|k, v| sum += (ProductItem.find(k).product.current_price * v.to_i) }
    sum
  end

  def paid
    sale = Sale.create
    result = 0
    items.each do |id, count|
      item = ProductItem.find(id)
      product = item.product
      price = product.current_price_model
      result += price.price.to_i*count.to_i
      item.update({count: (item.count - count.to_i)})
      SaleItem.create({sale_id: sale.id, product_item_id: item.id, count: count.to_i, product_price_id: price.id})
    end
    sale.update(price: result)
    sale.notify_buy
  end

  def notify
    message = "Клиент оставил заявку на сайте\nНомер: #{id}\nСумма: #{total_sum} рублей"
    VkMessage.run(message)
  end

  def self.first_url
    "order_requests"
  end
end
