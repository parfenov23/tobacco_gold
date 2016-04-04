class CreateBuys < ActiveRecord::Migration
  def change
    create_table :buys do |t|
      t.float :price, default: 0

      t.timestamps null: false
    end
  end
end
