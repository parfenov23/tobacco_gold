class Company < ActiveRecord::Base
  has_many :magazines
  has_many :providers
  has_many :products
  has_many :categories
  has_many :contacts
end
