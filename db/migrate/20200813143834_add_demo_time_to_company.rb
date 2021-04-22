class AddDemoTimeToCompany < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :demo_time, :string
    add_column :companies, :demo, :boolean, default: true
    add_column :companies, :max_count_magazine, :integer, default: 1
  end
end
