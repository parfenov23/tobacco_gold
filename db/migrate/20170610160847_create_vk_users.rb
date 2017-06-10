class CreateVkUsers < ActiveRecord::Migration
  def change
    create_table :vk_users do |t|
      t.string :domain

      t.timestamps null: false
    end
  end
end
