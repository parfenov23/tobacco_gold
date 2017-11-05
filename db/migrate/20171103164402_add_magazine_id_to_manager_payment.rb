class AddMagazineIdToManagerPayment < ActiveRecord::Migration
  def change
    add_column :manager_payments, :magazine_id, :integer
  end
end
