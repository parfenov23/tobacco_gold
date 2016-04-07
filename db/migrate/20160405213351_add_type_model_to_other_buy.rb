class AddTypeModelToOtherBuy < ActiveRecord::Migration
  def change
    add_column :other_buys, :type_mode, :boolean, default: true
  end
end
