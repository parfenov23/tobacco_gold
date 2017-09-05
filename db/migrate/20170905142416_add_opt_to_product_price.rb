class AddOptToProductPrice < ActiveRecord::Migration
  def change
    add_column :product_prices, :opt, :boolean, default: false
  end
end
