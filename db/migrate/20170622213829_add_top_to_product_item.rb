class AddTopToProductItem < ActiveRecord::Migration
  def change
    add_column :product_items, :top, :boolean, default: false
  end
end
