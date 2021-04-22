class CreateTransferItems < ActiveRecord::Migration[5.2]
  def change
    create_table :transfer_items do |t|
      t.integer :transfer_id
      t.integer :product_item_id
      t.integer :count
      t.integer :price

      t.timestamps null: false
    end
  end
end
