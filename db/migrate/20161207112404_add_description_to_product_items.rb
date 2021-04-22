class AddDescriptionToProductItems < ActiveRecord::Migration[5.2]
  def change
    add_column :product_items, :description, :text
    add_column :product_items, :image_url, :string
  end
end
