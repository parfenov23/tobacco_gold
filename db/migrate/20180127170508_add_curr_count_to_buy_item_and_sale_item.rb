class AddCurrCountToBuyItemAndSaleItem < ActiveRecord::Migration[5.2]
  def change
    add_column :buy_items, :curr_count, :integer, default: 0
    add_column :sale_items, :curr_count, :integer, default: 0
  end
end
