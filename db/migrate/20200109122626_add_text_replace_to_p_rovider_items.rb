class AddTextReplaceToPRoviderItems < ActiveRecord::Migration
  def change
    add_column :provider_items, :text_replace, :string
  end
end
