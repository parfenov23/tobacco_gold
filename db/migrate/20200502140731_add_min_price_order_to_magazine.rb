class AddMinPriceOrderToMagazine < ActiveRecord::Migration[5.2]
  def change
    add_column :magazines, :min_price_order, :integer
  end
end
