class CreateProductItemTopMagazines < ActiveRecord::Migration
  def change
    create_table :product_item_top_magazines do |t|
      t.integer :magazine_id
      t.integer :product_item_id

      t.timestamps null: false
    end
  end
end