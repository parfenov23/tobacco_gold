class ChangeProductItemInSaleItem < ActiveRecord::Migration[5.2]
  def change
    rename_column :sale_items, :product_item, :product_item_id
  end
end
