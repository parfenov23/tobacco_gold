class Company < ActiveRecord::Base
  has_many :magazines
  has_many :providers
end
