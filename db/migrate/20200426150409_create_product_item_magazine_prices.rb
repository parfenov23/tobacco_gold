class CreateProductItemMagazinePrices < ActiveRecord::Migration[5.2]
  def change
    create_table :product_item_magazine_prices do |t|
      t.string :product_item_id
      t.string :integer
      t.integer :magazine_id
      t.integer :price_id

      t.timestamps null: false
    end
  end
end
