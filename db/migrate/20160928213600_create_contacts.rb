class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :first_name
      t.string :phone
      t.string :social

      t.timestamps null: false
    end
  end
end