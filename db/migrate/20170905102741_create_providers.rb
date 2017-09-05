class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.string :title

      t.timestamps null: false
    end
  end
end
