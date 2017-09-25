class AddVisaToSales < ActiveRecord::Migration
  def change
    add_column :sales, :visa, :boolean, default: false
  end
end
