class AddPriceDeliveryToMagazine < ActiveRecord::Migration[5.2]
  def change
    add_column :magazines, :price_delivery, :string
  end
end
