class CreateCachboxItems < ActiveRecord::Migration
  def change
    create_table :cachbox_items do |t|
      t.string :cachbox_item_table_type
      t.integer :cashbox_item_table_id
      t.integer :price
      t.string :type_cash
      t.boolean :type_mode
      t.integer :current_cash

      t.timestamps null: false
    end
  end
end
