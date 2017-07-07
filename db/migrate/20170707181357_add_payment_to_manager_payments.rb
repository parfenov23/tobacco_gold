class AddPaymentToManagerPayments < ActiveRecord::Migration
  def change
    add_column :manager_payments, :payment, :boolean, default: false
  end
end
