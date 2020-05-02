class AddMinPriceOrderToMagazine < ActiveRecord::Migration
  def change
    add_column :magazines, :min_price_order, :integer
  end
end
