class AddMagazinIdToCashbox < ActiveRecord::Migration
  def change
    add_column :cashboxes, :magazine_id, :integer
  end
end
