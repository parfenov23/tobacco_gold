class AddYaMetrikaToMagazine < ActiveRecord::Migration[5.2]
  def change
    add_column :magazines, :ya_metrika, :text
  end
end
