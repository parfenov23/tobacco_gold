class AddImgToCategory < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :img, :text
  end
end
