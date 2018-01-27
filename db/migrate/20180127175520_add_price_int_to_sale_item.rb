class AddPriceIntToSaleItem < ActiveRecord::Migration
  def change
    add_column :sale_items, :price_int, :integer, default: 0
  end
end
