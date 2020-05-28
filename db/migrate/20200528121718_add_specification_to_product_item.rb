class AddSpecificationToProductItem < ActiveRecord::Migration
  def change
    add_column :product_items, :specification, :text
  end
end
