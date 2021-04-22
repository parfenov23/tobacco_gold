class AddProcentSaleToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :procent_sale, :integer, default: 0
  end
end
