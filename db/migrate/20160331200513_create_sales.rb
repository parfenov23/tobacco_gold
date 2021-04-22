class CreateSales < ActiveRecord::Migration[5.2]
  def change
    create_table :sales do |t|

      t.timestamps null: false
    end
  end
end
