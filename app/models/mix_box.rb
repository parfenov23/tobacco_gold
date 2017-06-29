class MixBox < ActiveRecord::Base
  has_many :mix_box_items

  def self.first_url
    "mix_boxes"
  end
end
