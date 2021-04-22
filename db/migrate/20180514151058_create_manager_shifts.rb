class CreateManagerShifts < ActiveRecord::Migration[5.2]
  def change
    create_table :manager_shifts do |t|
      t.integer :user_id
      t.string :status
      t.integer :cash
      t.integer :visa
      t.integer :sum_sales

      t.timestamps null: false
    end
  end
end
