class AddVkApiKeyGroupToMagazine < ActiveRecord::Migration
  def change
    add_column :magazines, :vk_api_key_group, :string
  end
end
