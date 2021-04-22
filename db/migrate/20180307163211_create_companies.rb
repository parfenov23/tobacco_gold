class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
      t.string :title
      t.text :contact

      t.timestamps null: false
    end
  end
end
