class ContactPrice < ActiveRecord::Base
  belongs_to :contact
  belongs_to :product
  belongs_to :product_price

  def company_id
    contact.company_id
  end

  def self.first_url
    "contact_prices"
  end

  def title
    "#{product.title} - #{product_price.price} руб"
  end
end
