class AddMagazineIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :magazine_id, :integer
  end
end
