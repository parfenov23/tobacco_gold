class AddSpecificationToProductItem < ActiveRecord::Migration[5.2]
  def change
    add_column :product_items, :specification, :text
  end
end
