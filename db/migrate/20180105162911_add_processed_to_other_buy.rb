class AddProcessedToOtherBuy < ActiveRecord::Migration
  def change
    add_column :other_buys, :processed, :boolean, default: true
  end
end
