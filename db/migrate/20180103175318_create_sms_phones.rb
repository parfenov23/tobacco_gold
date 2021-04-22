class CreateSmsPhones < ActiveRecord::Migration[5.2]
  def change
    create_table :sms_phones do |t|
      t.string :address
      t.text :body
      t.string :date_time

      t.timestamps null: false
    end
  end
end
