class BuyItem < ActiveRecord::Base
  belongs_to :buy
  belongs_to :product_item
end
