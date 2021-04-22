class AddCountToProductItem < ActiveRecord::Migration[5.2]
  def change
    add_column :product_items, :count, :integer, default: 0
  end
end
