class AddProcessedToOtherBuy < ActiveRecord::Migration[5.2]
  def change
    add_column :other_buys, :processed, :boolean, default: true
  end
end
