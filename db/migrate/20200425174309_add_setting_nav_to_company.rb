class AddSettingNavToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :setting_nav, :string
  end
end
