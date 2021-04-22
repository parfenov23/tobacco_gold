class CreateOtherBuys < ActiveRecord::Migration[5.2]
  def change
    create_table :other_buys do |t|
      t.string :title
      t.float :price

      t.timestamps null: false
    end
  end
end
