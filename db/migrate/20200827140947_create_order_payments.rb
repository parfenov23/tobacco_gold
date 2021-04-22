class CreateOrderPayments < ActiveRecord::Migration[5.2]
  def change
    create_table :order_payments do |t|
      t.integer :company_id
      t.integer :amount
      t.boolean :payment
      t.text :params
      t.string :tariff
      t.string :payment_id
      t.integer :month

      t.timestamps null: false
    end
  end
end
