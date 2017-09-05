class Provider < ActiveRecord::Base
  has_many :provider_items

  def self.first_url
    "providers"
  end
end
