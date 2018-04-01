class AddVkApiKeyUserToMagazine < ActiveRecord::Migration
  def change
    add_column :magazines, :vk_api_key_user, :text
    add_column :magazines, :vk_chat_id, :string
  end
end
