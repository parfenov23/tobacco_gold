class AddUidToProductItem < ActiveRecord::Migration[5.2]
  def change
    add_column :product_items, :uid, :string
  end
end
