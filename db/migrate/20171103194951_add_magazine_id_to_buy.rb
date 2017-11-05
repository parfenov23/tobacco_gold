class AddMagazineIdToBuy < ActiveRecord::Migration
  def change
    add_column :buys, :magazine_id, :integer
  end
end
