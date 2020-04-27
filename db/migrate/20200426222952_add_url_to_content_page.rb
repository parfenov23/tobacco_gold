class AddUrlToContentPage < ActiveRecord::Migration
  def change
    add_column :content_pages, :url, :string
  end
end
