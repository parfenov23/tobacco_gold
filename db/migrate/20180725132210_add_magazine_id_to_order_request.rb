class AddMagazineIdToOrderRequest < ActiveRecord::Migration
  def change
    add_column :order_requests, :magazine_id, :integer
  end
end
