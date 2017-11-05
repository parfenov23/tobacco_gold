class AddMagazineIdToSale < ActiveRecord::Migration
  def change
    add_column :sales, :magazine_id, :integer
  end
end
