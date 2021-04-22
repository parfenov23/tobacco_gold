class AddMagazineIdToSale < ActiveRecord::Migration[5.2]
  def change
    add_column :sales, :magazine_id, :integer
  end
end
