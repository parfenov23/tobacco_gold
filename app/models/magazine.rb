class Magazine < ActiveRecord::Base
  has_one :cashbox, dependent: :destroy
  before_create :default_create_product_item_count

  def self.first_url
    "magazins"
  end

  def default_create_product_item_count
    all_ids = ProductItem.all.ids
    hash_array = all_ids.map{|id| {product_item_id: id, magazine_id: self.id, count: 0} }
    ProductItemCount.create(hash_array)
  end
end
