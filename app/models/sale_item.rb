class SaleItem < ActiveRecord::Base
  belongs_to :product_price
  belongs_to :product_item

  def title
    product_item.product.title + ": " + product_item.title
  end

  def price
    product_price.price rescue price_int
  end
end
