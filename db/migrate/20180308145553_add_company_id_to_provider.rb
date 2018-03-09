class AddCompanyIdToProvider < ActiveRecord::Migration
  def change
    add_column :providers, :company_id, :integer
  end
end
