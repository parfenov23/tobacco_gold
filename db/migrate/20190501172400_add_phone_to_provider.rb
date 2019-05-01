class AddPhoneToProvider < ActiveRecord::Migration
  def change
    add_column :providers, :phone, :string
  end
end
