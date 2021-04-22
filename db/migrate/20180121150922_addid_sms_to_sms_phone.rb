class AddidSmsToSmsPhone < ActiveRecord::Migration[5.2]
  def change
    add_column :sms_phones, :id_sms, :integer
    add_column :sms_phones, :sum, :integer
    add_column :sms_phones, :archive, :boolean, default: false
    add_column :sms_phones, :magazine_id, :integer
  end
end
