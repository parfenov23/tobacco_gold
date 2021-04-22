class AddApiKeyToMagazine < ActiveRecord::Migration[5.2]
  def change
    add_column :magazines, :api_key, :string
  end
end
