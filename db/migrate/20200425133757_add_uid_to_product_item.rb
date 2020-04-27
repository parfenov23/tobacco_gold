class AddUidToProductItem < ActiveRecord::Migration
  def change
    add_column :product_items, :uid, :string
  end
end
