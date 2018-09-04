class AddInStockToSale < ActiveRecord::Migration
  def change
    add_column :sales, :in_stock, :boolean, default: false
  end
end
