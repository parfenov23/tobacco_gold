class AddLogoToMagazine < ActiveRecord::Migration
  def change
    add_column :magazines, :logo, :text
  end
end
