class AddContactIdToOrderRequest < ActiveRecord::Migration
  def change
    add_column :order_requests, :contact_id, :integer
  end
end
