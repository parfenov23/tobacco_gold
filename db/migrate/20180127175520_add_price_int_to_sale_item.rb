class AddPriceIntToSaleItem < ActiveRecord::Migration[5.2]
  def change
    add_column :sale_items, :price_int, :integer, default: 0
  end
end
