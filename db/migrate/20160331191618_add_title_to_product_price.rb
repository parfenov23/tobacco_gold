class AddTitleToProductPrice < ActiveRecord::Migration
  def change
    add_column :product_prices, :title, :string
  end
end
