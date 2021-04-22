class AddPriceToSaleItem < ActiveRecord::Migration[5.2]
  def change
    add_column :sale_items, :product_price_id, :integer
  end
end
