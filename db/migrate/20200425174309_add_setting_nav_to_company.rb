class AddSettingNavToCompany < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :setting_nav, :string
  end
end
