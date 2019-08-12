class AddPhoneSmsToMagazine < ActiveRecord::Migration
  def change
    add_column :magazines, :phone_sms, :string
    add_column :magazines, :cart_number, :string
  end
end
