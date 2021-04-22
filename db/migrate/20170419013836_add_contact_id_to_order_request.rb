class AddContactIdToOrderRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :order_requests, :contact_id, :integer
  end
end
