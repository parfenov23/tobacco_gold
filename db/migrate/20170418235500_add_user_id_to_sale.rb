class AddUserIdToSale < ActiveRecord::Migration[5.2]
  def change
    add_column :sales, :user_id, :integer
  end
end
