class AddItemsToOrderRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :order_requests, :items, :hstore, default: {}, null: false
  end
end
