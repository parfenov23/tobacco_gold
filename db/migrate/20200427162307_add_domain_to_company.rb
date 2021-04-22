class AddDomainToCompany < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :domain, :string
  end
end
