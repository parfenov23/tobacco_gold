class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.string :title
      t.integer :sum, default: 0
      t.integer :order_id

      t.timestamps null: false
    end
  end
end
