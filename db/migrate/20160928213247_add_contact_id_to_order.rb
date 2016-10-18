class AddContactIdToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :contact_id, :integer
    add_column :orders, :hash_id, :string
  end
end
