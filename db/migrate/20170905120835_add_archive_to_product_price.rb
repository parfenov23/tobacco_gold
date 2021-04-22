class AddArchiveToProductPrice < ActiveRecord::Migration[5.2]
  def change
    add_column :product_prices, :archive, :boolean, default: false
  end
end
