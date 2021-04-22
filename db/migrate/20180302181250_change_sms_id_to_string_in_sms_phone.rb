class ChangeSmsIdToStringInSmsPhone < ActiveRecord::Migration[5.2]
  def change
    change_column :sms_phones, :id_sms, :string
  end
end
