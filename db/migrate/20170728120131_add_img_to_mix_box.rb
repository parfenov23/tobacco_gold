class AddImgToMixBox < ActiveRecord::Migration
  def change
    add_column :mix_boxes, :img, :text
  end
end
