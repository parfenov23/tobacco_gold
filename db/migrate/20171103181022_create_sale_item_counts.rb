class CreateSaleItemCounts < ActiveRecord::Migration
  def change
    create_table :product_item_counts do |t|
      t.integer :product_item_id
      t.integer :magazine_id
      t.integer :count

      t.timestamps null: false
    end
  end
end
