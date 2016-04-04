class Product < ActiveRecord::Base
  has_many :product_items
  has_many :product_prices
end
