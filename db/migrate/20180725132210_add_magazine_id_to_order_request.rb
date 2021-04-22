class AddMagazineIdToOrderRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :order_requests, :magazine_id, :integer
  end
end
