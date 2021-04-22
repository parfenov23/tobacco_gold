class AddInStockToSale < ActiveRecord::Migration[5.2]
  def change
    add_column :sales, :in_stock, :boolean, default: false
  end
end
