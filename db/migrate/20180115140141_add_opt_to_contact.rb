class AddOptToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :opt, :boolean, default: false
  end
end
