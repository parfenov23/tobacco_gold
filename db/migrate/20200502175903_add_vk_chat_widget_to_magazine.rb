class AddVkChatWidgetToMagazine < ActiveRecord::Migration
  def change
    add_column :magazines, :vk_chat_widget, :text
  end
end
