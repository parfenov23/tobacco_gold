class AddOptToContact < ActiveRecord::Migration[5.2]
  def change
    add_column :contacts, :opt, :boolean, default: false
  end
end
