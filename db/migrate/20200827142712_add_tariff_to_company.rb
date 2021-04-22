class AddTariffToCompany < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :tariff, :string
    add_column :companies, :help_notify, :boolean, default: false
  end
end
