class CreateBuySearches < ActiveRecord::Migration[5.2]
  def change
    create_table :buy_searches do |t|
      t.integer :company_id
      t.string :title
      t.integer :product_item_id

      t.timestamps null: false
    end
  end
end
