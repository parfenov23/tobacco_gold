class AddTextReplaceToPRoviderItems < ActiveRecord::Migration[5.2]
  def change
    add_column :provider_items, :text_replace, :string
  end
end
