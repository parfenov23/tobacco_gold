class ProductPrice < ActiveRecord::Base
  belongs_to :product
  scope :curr_default_id, -> { where(default: true).first.id rescue nil }
  scope :curr_opt_id, -> { where(opt: true).first.id rescue nil }

  def self.first_url
    "product_prices"
  end

  def update_default
    product.product_prices.update_all(default: false)
  end

  def company_id
    product.company_id
  end
end
