class AddMagazinIdToCashbox < ActiveRecord::Migration[5.2]
  def change
    add_column :cashboxes, :magazine_id, :integer
  end
end
