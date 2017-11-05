class CreateMagazines < ActiveRecord::Migration
  def change
    create_table :magazines do |t|
      t.string :title
      t.string :address
      t.string :phone

      t.timestamps null: false
    end
  end
end
