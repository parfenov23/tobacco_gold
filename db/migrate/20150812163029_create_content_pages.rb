class CreateContentPages < ActiveRecord::Migration
  def change
    create_table :content_pages do |t|
      t.string :name_page
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
