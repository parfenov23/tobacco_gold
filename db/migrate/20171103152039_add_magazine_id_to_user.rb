class AddMagazineIdToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :magazine_id, :integer
  end
end
