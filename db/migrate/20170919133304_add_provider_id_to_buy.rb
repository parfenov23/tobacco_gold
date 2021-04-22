class AddProviderIdToBuy < ActiveRecord::Migration[5.2]
  def change
    add_column :buys, :provider_id, :integer
  end
end
