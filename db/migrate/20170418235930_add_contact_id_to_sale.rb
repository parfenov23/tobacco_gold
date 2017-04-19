class AddContactIdToSale < ActiveRecord::Migration
  def change
    add_column :sales, :contact_id, :integer
  end
end
