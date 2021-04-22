class AddOptToProductPrice < ActiveRecord::Migration[5.2]
  def change
    add_column :product_prices, :opt, :boolean, default: false
  end
end
