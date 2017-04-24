class AddProcentSaleToUser < ActiveRecord::Migration
  def change
    add_column :users, :procent_sale, :integer, default: 0
  end
end
