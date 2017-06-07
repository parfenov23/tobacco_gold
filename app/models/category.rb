class Category < ActiveRecord::Base
  has_many :items, :dependent => :destroy
  has_many :products
end
