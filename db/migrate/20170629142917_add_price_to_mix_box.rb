class AddPriceToMixBox < ActiveRecord::Migration
  def change
    add_column :mix_boxes, :price, :integer
  end
end
