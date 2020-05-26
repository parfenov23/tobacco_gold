class ChangeProductItemForProductItemMagazinePrice < ActiveRecord::Migration
  def change
    change_column :product_item_magazine_prices, :product_item_id, 'integer USING CAST(product_item_id AS integer)'
    remove_column :product_item_magazine_prices, :integer
  end
end
