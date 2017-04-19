class CreateManagerPayments < ActiveRecord::Migration
  def change
    create_table :manager_payments do |t|
      t.integer :user_id
      t.integer :price

      t.timestamps null: false
    end
  end
end
