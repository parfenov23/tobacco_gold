class AddImgToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :img, :text
  end
end
