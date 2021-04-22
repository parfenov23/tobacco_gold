class AddMagazineIdToContentPage < ActiveRecord::Migration[5.2]
  def change
    add_column :content_pages, :magazine_id, :integer
  end
end
