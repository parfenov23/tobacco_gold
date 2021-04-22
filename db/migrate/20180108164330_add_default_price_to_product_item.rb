class AddDefaultPriceToProductItem < ActiveRecord::Migration[5.2]
  def change
    add_column :product_items, :price_id, :integer
  end
end
