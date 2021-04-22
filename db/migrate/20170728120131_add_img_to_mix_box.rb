class AddImgToMixBox < ActiveRecord::Migration[5.2]
  def change
    add_column :mix_boxes, :img, :text
  end
end
