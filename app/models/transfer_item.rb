class TransferItem < ActiveRecord::Base
  belongs_to :transfer
  belongs_to :product_item
end
