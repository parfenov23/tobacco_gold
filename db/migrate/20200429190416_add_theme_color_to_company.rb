class AddThemeColorToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :theme_color, :string
  end
end
