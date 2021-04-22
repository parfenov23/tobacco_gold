class CreateMixBoxes < ActiveRecord::Migration[5.2]
  def change
    create_table :mix_boxes do |t|
      t.string :title
      t.text :description

      t.timestamps null: false
    end
  end
end
