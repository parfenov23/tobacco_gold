class AddProfitToSale < ActiveRecord::Migration[5.2]
  def change
    add_column :sales, :profit, :integer, default: 0
  end
end
