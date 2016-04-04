class CreateProductItems < ActiveRecord::Migration
  def change
    create_table :product_items do |t|
      t.string :title
      t.integer :product_id

      t.timestamps null: false
    end
  end
end
