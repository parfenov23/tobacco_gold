class AddMagazineIdToBuy < ActiveRecord::Migration[5.2]
  def change
    add_column :buys, :magazine_id, :integer
  end
end
