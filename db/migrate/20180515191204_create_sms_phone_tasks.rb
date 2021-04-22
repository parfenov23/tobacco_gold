class CreateSmsPhoneTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :sms_phone_tasks do |t|
      t.string :phone
      t.string :body
      t.boolean :status, default: false
      t.integer :magazine_id
      t.string :sms_id

      t.timestamps null: false
    end
  end
end
