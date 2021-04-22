class AddPaidOutToBuy < ActiveRecord::Migration[5.2]
  def change
    add_column :buys, :paid_out, :integer
  end
end
