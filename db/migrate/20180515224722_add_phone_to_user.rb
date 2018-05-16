class AddPhoneToUser < ActiveRecord::Migration
  def change
    add_column :users, :phone, :string
    add_column :users, :auto_payment, :boolean, default: false
  end
end
