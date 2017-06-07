class AddInStockToProductItem < ActiveRecord::Migration
  def change
    add_column :product_items, :in_stock, :boolean, default: false
  end
end
