class AddItemsToOrderRequest < ActiveRecord::Migration
  def change
    add_column :order_requests, :items, :hstore, default: {}, null: false
  end
end
