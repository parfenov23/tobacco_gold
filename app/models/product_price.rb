class ProductPrice < ActiveRecord::Base
  belongs_to :product
  scope :curr_default_id, -> { where(default: true).first.id rescue nil }

  def update_default
    # binding.pry
    product.product_prices.update_all(default: false)
    #update_attribute(:default, true)
    # binding.pry
  end
end
