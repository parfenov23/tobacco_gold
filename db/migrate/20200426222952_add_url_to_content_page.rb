class AddUrlToContentPage < ActiveRecord::Migration[5.2]
  def change
    add_column :content_pages, :url, :string
  end
end
