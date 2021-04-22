class AddVkChatWidgetToMagazine < ActiveRecord::Migration[5.2]
  def change
    add_column :magazines, :vk_chat_widget, :text
  end
end
