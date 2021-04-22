class AddFullTextToSmsPhone < ActiveRecord::Migration[5.2]
  def change
    add_column :sms_phones, :full_text, :text
  end
end
