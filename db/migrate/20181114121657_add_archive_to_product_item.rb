class AddArchiveToProductItem < ActiveRecord::Migration[5.2]
  def change
    add_column :product_items, :archive, :boolean, default: false
  end
end
