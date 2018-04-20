class AddFullTextToSmsPhone < ActiveRecord::Migration
  def change
    add_column :sms_phones, :full_text, :text
  end
end
