class AddInStockToProductItem < ActiveRecord::Migration[5.2]
  def change
    add_column :product_items, :in_stock, :boolean, default: false
  end
end
