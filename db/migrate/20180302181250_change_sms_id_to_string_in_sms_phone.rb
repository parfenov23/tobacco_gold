class ChangeSmsIdToStringInSmsPhone < ActiveRecord::Migration
  def change
    change_column :sms_phones, :id_sms, :string
  end
end
