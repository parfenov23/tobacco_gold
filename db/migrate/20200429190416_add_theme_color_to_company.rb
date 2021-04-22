class AddThemeColorToCompany < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :theme_color, :string
  end
end
