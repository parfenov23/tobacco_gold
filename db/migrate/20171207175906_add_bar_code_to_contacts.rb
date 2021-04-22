class AddBarCodeToContacts < ActiveRecord::Migration[5.2]
  def change
    add_column :contacts, :barcode, :string
    add_column :contacts, :purse, :integer, default: 0
    add_column :contacts, :cashback, :integer, default: 2
  end
end
