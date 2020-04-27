class CreateProductItemsTags < ActiveRecord::Migration
  def change
    create_table :product_items_tags do |t|
      t.integer :product_item_id
      t.integer :tag_id

      t.timestamps null: false
    end
  end
end
