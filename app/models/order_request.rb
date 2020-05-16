require 'vk_message'
require 'send_sms'
class OrderRequest < ActiveRecord::Base
  belongs_to :user
  belongs_to :contact
  belongs_to :magazine
  # serialize :basket, ActiveRecord::Coders::NestedHstore
  scope :waitings, -> {where(status: "waiting")}
  default_scope { order("created_at DESC") }

  def title
    "Заявка №#{id} от #{(created_at + 3.hour).strftime('%d.%m.%y %H:%M')}"
  end

  def total_sum
    sum = 0
    items.map {|k, v| 
      item_product = ProductItem.find(k)
      item_hash = item(k)
      curr_price = current_price(item_product)
      sum += (curr_price * item_hash[:count].to_i)
    }
    sum
  end

  def paid(user_id=nil, type_cash="cash")
    sale = Sale.create(user_id: user_id, contact_id: contact_id, visa: (type_cash == "visa"))
    result = 0
    curr_user = User.find(user_id)
    items.each do |id, count|
      item = ProductItem.find(id)
      item_hash = self.item(id)
      product = item.product
      price = current_price(item)
      result += price*item_hash[:count].to_i
      current_item_count = item.product_item_counts.find_by_magazine_id(curr_user.magazine_id)
      curr_count = current_item_count.count
      current_item_count.update({count: (curr_count - item_hash[:count].to_i) })
      price_id = product.product_prices.where(price: price).last.id
      SaleItem.create({sale_id: sale.id, product_item_id: item.id, count: item_hash[:count].to_i, product_price_id: price_id, curr_count: curr_count})
    end
    purse = contact.purse + (result.to_f/100*contact.current_cashback).round
    contact.update(purse: purse)
    sale.update(price: result, profit: sale.find_profit, magazine_id: curr_user.magazine_id)
    sale.notify_buy
  end

  def item(id_item)
    result = eval(items[id_item.to_s]) rescue {count: items[id_item.to_s]}
    result.is_a?(Hash) ? result : {count: result}
  end

  def current_price(product_item)
    price_id = item(product_item.id)[:price_id].blank? ? product_item.price_id(magazine_id) : item(product_item.id)[:price_id]
    ProductPrice.find(price_id).price
  end

  def price
    result = 0
    items.each do |id, count|
      product_item = ProductItem.find(id)
      product = product_item.product
      item_hash = item(id)
      price = current_price(product_item)
      result += price.to_i*item_hash[:count].to_i
    end
    result
  end

  def sorty_by_product
    new_hash = {}
    items.each do |k, v|
      product_item = ProductItem.find(k)
      item_info = item(k)
      item_hash = [{product_item: product_item, count: item_info[:count], price_id: item_info[:price_id]}]
      new_hash[product_item.product_id] = new_hash[product_item.product_id].present? ? (new_hash[product_item.product_id] + item_hash) : item_hash
    end
    new_hash.sort
  end


  def notify
    message = "Клиент оставил заявку на сайте\nНомер: #{id}\nИмя: #{contact.first_name}\nТелефон: #{contact.phone}\nСумма: #{total_sum} рублей"
    if magazine.vk_api_key_user.present?
      VkMessage.run(message, "user", {access_token: magazine.vk_api_key_user, chat_id: magazine.vk_chat_id}) if Rails.env.production?
    end
    SendSms.sender([contact.phone], "Ваш заказ №#{id} принят!")
    Thread.new do
      magazine.users.where(role: "manager").each do |user|
        OrderRequestMail.sample_email(self, user.email).deliver_now
      end
    end
  end

  def self.first_url
    "order_requests"
  end

  def self.all_satuses
    [
      {title: "Новая", id: "waiting"}, 
      {title: "В работе", id: "work"}, 
      {title: "Передано в доставку", id: "delivery"}, 
      {title: "Оплачено", id: "paid"}
    ]
  end

  def self.next_status(status)
    all_satuses[(all_satuses.index{|e| e[:id] == status} + 1)][:id]
  end
end
