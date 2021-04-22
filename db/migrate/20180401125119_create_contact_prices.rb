class CreateContactPrices < ActiveRecord::Migration[5.2]
  def change
    create_table :contact_prices do |t|
      t.integer :contact_id
      t.integer :product_id
      t.integer :product_price_id

      t.timestamps null: false
    end
  end
end
