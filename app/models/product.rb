class Product < ActiveRecord::Base
  has_many :product_items, dependent: :destroy
  has_many :product_prices, dependent: :destroy
  default_scope { order("title ASC") }

  def min_price
    items_ids = product_items.ids
    buy_items = BuyItem.where(id: items_ids).where(["price > ?", 50])
    buy_items.present? ? buy_items.map(&:price).min : product_prices.map(&:price).min
  end

  def self.stock_price
    result = 0
    all.each do |product|
      result += (product.min_price * product.product_items.sum(:count) )
    end
    result
  end
end
