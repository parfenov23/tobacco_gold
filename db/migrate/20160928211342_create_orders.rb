class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer :sum, default: 0
      t.boolean :pay, default: false
      t.integer :profit, default: 0

      t.timestamps null: false
    end
  end
end
