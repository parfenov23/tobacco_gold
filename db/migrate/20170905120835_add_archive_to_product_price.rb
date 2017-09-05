class AddArchiveToProductPrice < ActiveRecord::Migration
  def change
    add_column :product_prices, :archive, :boolean, default: false
  end
end
