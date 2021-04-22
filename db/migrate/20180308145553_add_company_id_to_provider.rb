class AddCompanyIdToProvider < ActiveRecord::Migration[5.2]
  def change
    add_column :providers, :company_id, :integer
  end
end
