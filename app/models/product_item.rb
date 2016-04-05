class ProductItem < ActiveRecord::Base
  belongs_to :product
  has_many :buy_items, dependent: :destroy
  has_many :sale_items, dependent: :destroy
  default_scope { order('title DESC') }
end
