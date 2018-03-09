class AddCompanyIdToOrderRequest < ActiveRecord::Migration
  def change
    add_column :order_requests, :company_id, :integer
  end
end
