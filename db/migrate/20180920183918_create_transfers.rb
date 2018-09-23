class CreateTransfers < ActiveRecord::Migration
  def change
    create_table :transfers do |t|
      t.integer :magazine_id_from
      t.integer :magazine_id_to
      t.integer :sum
      t.integer :company_id
      t.boolean :paid, default: false
      t.boolean :visa, default: false

      t.timestamps null: false
    end
  end
end
