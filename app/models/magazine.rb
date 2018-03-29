class Magazine < ActiveRecord::Base
  has_one :cashbox, dependent: :destroy
  belongs_to :company
  has_many :product_item_counts, dependent: :destroy
  after_create :default_create_product_item_count

  def self.first_url
    "magazins"
  end

  def default_create_product_item_count
    Cashbox.create(magazine_id: id, cash: 0, visa: 0)
    all_ids = ProductItem.where(product_id: Product.where(company_id: company_id).ids).ids
    hash_array = all_ids.map{|id| {product_item_id: id, magazine_id: self.id, count: 0} }
    ProductItemCount.create(hash_array)
  end
end
