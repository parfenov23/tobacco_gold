class CreateProductPrices < ActiveRecord::Migration
  def change
    create_table :product_prices do |t|
      t.float :price, default: 0
      t.integer :product_id

      t.timestamps null: false
    end
  end
end
