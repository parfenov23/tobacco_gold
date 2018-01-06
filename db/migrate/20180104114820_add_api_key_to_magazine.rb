class AddApiKeyToMagazine < ActiveRecord::Migration
  def change
    add_column :magazines, :api_key, :string
  end
end
