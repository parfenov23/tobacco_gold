class AddAdressToOrderRequest < ActiveRecord::Migration
  def change
    add_column :order_requests, :address, :string
    add_column :order_requests, :type_payment, :string
  end
end
