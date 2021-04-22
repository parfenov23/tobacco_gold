class AddDefaultToProductPrice < ActiveRecord::Migration[5.2]
  def change
    add_column :product_prices, :default, :boolean, {default: false}
  end
end
