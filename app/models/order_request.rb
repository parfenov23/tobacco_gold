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
    items.map {|k, v| 
      item_product = ProductItem.find(k).product
      curr_price = !contact.opt ? item_product.current_price : item_product.current_price_opt
      sum += (curr_price * v.to_i) 
    }
    sum
  end

  def paid(user_id=nil, contact_id=nil)
    sale = Sale.create(user_id: user_id, contact_id: contact_id)
    result = 0
    curr_user = User.find(user_id)
    items.each do |id, count|
      item = ProductItem.find(id)
      product = item.product
      price = !contact.opt ? product.current_price_model : product.current_price_opt_model
      result += price.price.to_i*count.to_i
      current_item_count = item.product_item_counts.find_by_magazine_id(curr_user.magazine_id)
      curr_count = current_item_count.count
      current_item_count.update({count: (curr_count - count.to_i) })
      item.update({count: (item.count - count.to_i) })
      SaleItem.create({sale_id: sale.id, product_item_id: item.id, count: count.to_i, product_price_id: price.id, curr_count: curr_count})
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

  def sorty_by_product
    new_hash = {}
    items.each do |k, v|
      product_item = ProductItem.find(k)
      item_hash = [{product_item: product_item, count: v}]
      new_hash[product_item.product_id] = new_hash[product_item.product_id].present? ? (new_hash[product_item.product_id] + item_hash) : item_hash
    end
    new_hash.sort
  end


  def notify
    message = "Клиент оставил заявку на сайте\nНомер: #{id}\nСумма: #{total_sum} рублей"
    Magazine.where.not(vk_api_key_user: nil).each do |magazine|
      VkMessage.run(message, "user", {access_token: magazine.vk_api_key_user, chat_id: magazine.vk_chat_id}) if Rails.env.production?
    end
  end

  def self.first_url
    "order_requests"
  end
end
