class Provider < ActiveRecord::Base
  has_many :provider_items
  has_many :buys

  def self.first_url
    "providers"
  end
end
