class AddCompanyIdToOrderRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :order_requests, :company_id, :integer
  end
end
