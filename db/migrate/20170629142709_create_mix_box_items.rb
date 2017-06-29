class CreateMixBoxItems < ActiveRecord::Migration
  def change
    create_table :mix_box_items do |t|
      t.integer :mix_box_id
      t.string :product_item_id
      t.integer :procent

      t.timestamps null: false
    end
  end
end
