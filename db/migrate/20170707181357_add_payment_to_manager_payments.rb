class AddPaymentToManagerPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :manager_payments, :payment, :boolean, default: false
  end
end
