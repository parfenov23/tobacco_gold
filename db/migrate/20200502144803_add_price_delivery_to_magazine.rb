class AddPriceDeliveryToMagazine < ActiveRecord::Migration
  def change
    add_column :magazines, :price_delivery, :string
  end
end
