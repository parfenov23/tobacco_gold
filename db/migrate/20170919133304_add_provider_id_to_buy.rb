class AddProviderIdToBuy < ActiveRecord::Migration
  def change
    add_column :buys, :provider_id, :integer
  end
end
