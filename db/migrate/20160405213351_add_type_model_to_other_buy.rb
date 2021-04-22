class AddTypeModelToOtherBuy < ActiveRecord::Migration[5.2]
  def change
    add_column :other_buys, :type_mode, :boolean, default: true
  end
end
