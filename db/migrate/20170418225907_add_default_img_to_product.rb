class AddDefaultImgToProduct < ActiveRecord::Migration
  def change
    add_column :products, :default_img, :text
  end
end
