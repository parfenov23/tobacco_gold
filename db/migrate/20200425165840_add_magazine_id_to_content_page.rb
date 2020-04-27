class AddMagazineIdToContentPage < ActiveRecord::Migration
  def change
    add_column :content_pages, :magazine_id, :integer
  end
end
