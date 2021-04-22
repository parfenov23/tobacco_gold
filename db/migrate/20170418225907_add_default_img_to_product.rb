class AddDefaultImgToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :default_img, :text
  end
end
