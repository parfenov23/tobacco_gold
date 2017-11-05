class AddMagazineIdToOtherBuy < ActiveRecord::Migration
  def change
    add_column :other_buys, :magazine_id, :integer
  end
end
