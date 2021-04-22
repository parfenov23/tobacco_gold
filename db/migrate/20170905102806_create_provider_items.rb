class CreateProviderItems < ActiveRecord::Migration[5.2]
  def change
    create_table :provider_items do |t|
      t.integer :product_id
      t.integer :provider_id
      t.integer :price

      t.timestamps null: false
    end
  end
end
