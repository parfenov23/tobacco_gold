class AddTitleToProductPrice < ActiveRecord::Migration[5.2]
  def change
    add_column :product_prices, :title, :string
  end
end
