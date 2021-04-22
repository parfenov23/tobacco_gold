class AddCommentToOrderRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :order_requests, :comment, :text
  end
end
