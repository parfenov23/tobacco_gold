class AddArchiveToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :archive, :boolean, default: false
  end
end
