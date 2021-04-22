class CreateOrderRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :order_requests do |t|
      t.integer :user_id
      t.string :user_name
      t.string :user_phone
      t.string :status
      t.text :basket

      t.timestamps null: false
    end
  end
end
