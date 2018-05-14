class AddSumShiftToUser < ActiveRecord::Migration
  def change
    add_column :users, :sum_shift, :integer, default: 0
  end
end
