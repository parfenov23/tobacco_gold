class CreateVkUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :vk_users do |t|
      t.string :domain

      t.timestamps null: false
    end
  end
end
