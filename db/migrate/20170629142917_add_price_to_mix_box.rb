class AddPriceToMixBox < ActiveRecord::Migration[5.2]
  def change
    add_column :mix_boxes, :price, :integer
  end
end
