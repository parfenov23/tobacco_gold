class AddCompanyIdToMagazine < ActiveRecord::Migration[5.2]
  def change
    add_column :magazines, :company_id, :integer
  end
end
