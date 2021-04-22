class BuyItem < ActiveRecord::Base
  belongs_to :buy, required: false
  belongs_to :product_item, required: false

end
