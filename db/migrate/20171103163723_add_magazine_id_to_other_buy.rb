class AddMagazineIdToOtherBuy < ActiveRecord::Migration[5.2]
  def change
    add_column :other_buys, :magazine_id, :integer
  end
end
