class AddArchiveToProductItem < ActiveRecord::Migration
  def change
    add_column :product_items, :archive, :boolean, default: false
  end
end
