class AddCompanyIdToContact < ActiveRecord::Migration[5.2]
  def change
    add_column :contacts, :company_id, :integer
  end
end
