class CreateBuyItems < ActiveRecord::Migration[5.2]
  def change
    create_table :buy_items do |t|
      t.integer :buy_id
      t.integer :product_item_id
      t.float :price
      t.float :count

      t.timestamps null: false
    end
  end
end
