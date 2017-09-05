class ProviderItem < ActiveRecord::Base
  belongs_to :provider
  belongs_to :product

  def self.first_url
    "provider_items"
  end

  def title
    "#{product.title} - #{price}"
  end
end
