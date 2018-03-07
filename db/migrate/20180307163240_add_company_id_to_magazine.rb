class AddCompanyIdToMagazine < ActiveRecord::Migration
  def change
    add_column :magazines, :company_id, :integer
  end
end
