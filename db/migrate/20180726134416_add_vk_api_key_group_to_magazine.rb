class AddVkApiKeyGroupToMagazine < ActiveRecord::Migration[5.2]
  def change
    add_column :magazines, :vk_api_key_group, :string
  end
end
