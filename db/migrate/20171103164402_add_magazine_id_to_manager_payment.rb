class AddMagazineIdToManagerPayment < ActiveRecord::Migration[5.2]
  def change
    add_column :manager_payments, :magazine_id, :integer
  end
end
