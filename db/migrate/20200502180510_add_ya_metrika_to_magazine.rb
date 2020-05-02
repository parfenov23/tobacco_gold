class AddYaMetrikaToMagazine < ActiveRecord::Migration
  def change
    add_column :magazines, :ya_metrika, :text
  end
end
