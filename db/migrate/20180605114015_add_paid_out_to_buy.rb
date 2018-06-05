class AddPaidOutToBuy < ActiveRecord::Migration
  def change
    add_column :buys, :paid_out, :integer
  end
end
