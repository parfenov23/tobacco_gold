class AddTopToProductItem < ActiveRecord::Migration[5.2]
  def change
    add_column :product_items, :top, :boolean, default: false
  end
end
