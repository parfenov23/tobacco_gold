class AddCompanyIdToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :company_id, :integer
  end
end
