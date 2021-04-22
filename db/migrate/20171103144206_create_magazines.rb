class CreateMagazines < ActiveRecord::Migration[5.2]
  def change
    create_table :magazines do |t|
      t.string :title
      t.string :address
      t.string :phone

      t.timestamps null: false
    end
  end
end
