class CreateHistoryVks < ActiveRecord::Migration
  def change
    create_table :history_vks do |t|
      t.text :params_type

      t.timestamps null: false
    end
  end
end
