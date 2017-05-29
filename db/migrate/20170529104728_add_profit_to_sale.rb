class AddProfitToSale < ActiveRecord::Migration
  def change
    add_column :sales, :profit, :integer, default: 0
  end
end
