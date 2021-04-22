class AddPhoneSmsToMagazine < ActiveRecord::Migration[5.2]
  def change
    add_column :magazines, :phone_sms, :string
    add_column :magazines, :cart_number, :string
  end
end
