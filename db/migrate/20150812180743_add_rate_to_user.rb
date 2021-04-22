class AddRateToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :rate, :integer, default: 0
  end
end
