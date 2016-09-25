class AddDefaultToProductPrice < ActiveRecord::Migration
  def change
    add_column :product_prices, :default, :boolean, {default: false}
  end
end
