class AddApiKeyPushbulletToMagazine < ActiveRecord::Migration
  def change
    add_column :magazines, :api_key_pushbullet, :string
    add_column :magazines, :api_key_pushbullet_mobile, :string
  end
end
