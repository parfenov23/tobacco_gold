class MixBoxItem < ActiveRecord::Base
  belongs_to :mix_box
  belongs_to :product_item

  def title
    product_item_id.present? ? product_item.title : "Нет"
  end

  def self.first_url
    "mix_box_items"
  end
end
