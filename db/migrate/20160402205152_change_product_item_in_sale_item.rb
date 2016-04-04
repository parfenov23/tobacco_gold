class ChangeProductItemInSaleItem < ActiveRecord::Migration
  def change
    rename_column :sale_items, :product_item, :product_item_id
  end
end
