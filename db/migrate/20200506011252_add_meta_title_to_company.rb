class AddMetaTitleToCompany < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :meta_title, :string
    add_column :companies, :meta_description, :text
    add_column :companies, :meta_keywords, :text
    add_column :companies, :favicon_folder, :string
  end
end
