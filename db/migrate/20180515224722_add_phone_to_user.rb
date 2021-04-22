class AddPhoneToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :phone, :string
    add_column :users, :auto_payment, :boolean, default: false
  end
end
