class AddPriceToSaleItem < ActiveRecord::Migration
  def change
    add_column :sale_items, :product_price_id, :integer
  end
end
