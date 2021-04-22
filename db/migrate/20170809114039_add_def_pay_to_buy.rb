class AddDefPayToBuy < ActiveRecord::Migration[5.2]
  def change
    add_column :buys, :def_pay, :boolean, default: false
  end
end
