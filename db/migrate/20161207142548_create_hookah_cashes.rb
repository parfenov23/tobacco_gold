class CreateHookahCashes < ActiveRecord::Migration
  def change
    create_table :hookah_cashes do |t|
      t.string :title
      t.integer :price, default: 0
      t.boolean :type_mode, default: true

      t.timestamps null: false
    end
  end
end
