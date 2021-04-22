class AddReserveToOrderRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :order_requests, :reserve, :boolean, default: false
  end
end
