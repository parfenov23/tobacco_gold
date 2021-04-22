class CreateCashboxes < ActiveRecord::Migration[5.2]
  def change
    create_table :cashboxes do |t|
      t.integer :cash
      t.integer :visa

      t.timestamps null: false
    end
  end
end
