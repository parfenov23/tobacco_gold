class AddContactIdToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :contact_id, :integer
    add_column :orders, :hash_id, :string
  end
end
