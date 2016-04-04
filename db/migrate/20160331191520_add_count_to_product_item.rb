class AddCountToProductItem < ActiveRecord::Migration
  def change
    add_column :product_items, :count, :integer, default: 0
  end
end
