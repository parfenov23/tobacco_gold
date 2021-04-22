class AddSumShiftToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :sum_shift, :integer, default: 0
  end
end
