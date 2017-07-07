class AddCommentToOrderRequest < ActiveRecord::Migration
  def change
    add_column :order_requests, :comment, :text
  end
end
