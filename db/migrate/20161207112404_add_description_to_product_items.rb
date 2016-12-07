class AddDescriptionToProductItems < ActiveRecord::Migration
  def change
    add_column :product_items, :description, :text
    add_column :product_items, :image_url, :string
  end
end
