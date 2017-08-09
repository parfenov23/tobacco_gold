class AddDefPayToBuy < ActiveRecord::Migration
  def change
    add_column :buys, :def_pay, :boolean, default: false
  end
end
