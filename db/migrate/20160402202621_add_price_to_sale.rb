class AddPriceToSale < ActiveRecord::Migration[5.2]
  def change
    add_column :sales, :price, :float, default: 0
  end
end
