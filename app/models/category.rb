class Category < ActiveRecord::Base
  has_many :items, :dependent => :destroy
  has_many :products

  def self.first_url
    "categories"
  end
end
