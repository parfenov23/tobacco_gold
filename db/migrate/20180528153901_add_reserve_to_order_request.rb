class AddReserveToOrderRequest < ActiveRecord::Migration
  def change
    add_column :order_requests, :reserve, :boolean, default: false
  end
end
