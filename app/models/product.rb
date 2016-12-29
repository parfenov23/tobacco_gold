class Product < ActiveRecord::Base
  has_many :product_items, dependent: :destroy
  has_many :product_prices, dependent: :destroy
  default_scope { order("title ASC") }

  def min_price
    items_ids = product_items.ids
    buy_items = BuyItem.where(id: items_ids).where(["price > ?", 50])
    buy_items.present? ? buy_items.minimum(:price) : product_prices.minimum(:price)
  end

  def self.stock_price
    result = 0
    all.each do |product|
      result += (product.current_price * product.product_items.sum(:count) )
    end
    result
  end

  def current_price
    price = product_prices.find_by_default(true)
    (price.price rescue product_prices.minimum(:price)).to_i
  end

  def current_price_model
    product_prices.find_by_default(true)
  end
end
