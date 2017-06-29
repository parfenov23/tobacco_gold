class CreateMixBoxes < ActiveRecord::Migration
  def change
    create_table :mix_boxes do |t|
      t.string :title
      t.text :description

      t.timestamps null: false
    end
  end
end
