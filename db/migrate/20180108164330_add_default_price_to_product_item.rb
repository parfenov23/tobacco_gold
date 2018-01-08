class AddDefaultPriceToProductItem < ActiveRecord::Migration
  def change
    add_column :product_items, :price_id, :integer
  end
end
