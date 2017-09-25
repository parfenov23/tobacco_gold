class ProductPrice < ActiveRecord::Base
  belongs_to :product
  scope :curr_default_id, -> { where(default: true).first.id rescue nil }
  scope :curr_opt_id, -> { where(opt: true).first.id rescue nil }

  def self.first_url
    "product_prices"
  end

  def update_default
    # binding.pry
    product.product_prices.update_all(default: false)
    #update_attribute(:default, true)
    # binding.pry
  end
end
