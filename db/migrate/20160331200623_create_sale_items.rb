class CreateSaleItems < ActiveRecord::Migration[5.2]
  def change
    create_table :sale_items do |t|
      t.integer :sale_id
      t.integer :product_item
      t.integer :count, default: 0

      t.timestamps null: false
    end
  end
end
