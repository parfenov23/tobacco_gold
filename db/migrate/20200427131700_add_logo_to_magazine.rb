class AddLogoToMagazine < ActiveRecord::Migration[5.2]
  def change
    add_column :magazines, :logo, :text
  end
end
