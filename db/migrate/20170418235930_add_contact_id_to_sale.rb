class AddContactIdToSale < ActiveRecord::Migration[5.2]
  def change
    add_column :sales, :contact_id, :integer
  end
end
