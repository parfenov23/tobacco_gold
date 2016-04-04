class ProductItem < ActiveRecord::Base
  belongs_to :product
  default_scope { order('title DESC') }
end
