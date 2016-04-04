class AddPriceToSale < ActiveRecord::Migration
  def change
    add_column :sales, :price, :float, default: 0
  end
end
