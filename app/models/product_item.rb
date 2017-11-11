class ProductItem < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search,
                  :against => :title,
                  :using => {
                    :tsearch => {:any_word => true},
                    :dmetaphone => {:any_word => true, :sort_only => true},
                    :trigram => {
                      :threshold => 0.5
                    }
                  }

  belongs_to :product
  has_many :buy_items, dependent: :destroy
  has_many :sale_items, dependent: :destroy
  default_scope { order('title ASC') }
  scope :total_sum, -> { map{|pi| pi.product.current_price}.sum }
  has_many :product_item_counts, dependent: :destroy
  after_create :default_create_product_item_count

  def self.popular_sort(count_first=3)
  	products = self.all
  	products.find(
  		products.map{ |m| 
  			[m.id, m.sale_items.count] 
  		}.to_h.sort_by(&:last).reverse.first(count_first).to_h.keys)
  end

  def self.first_url
    "product_items"
  end

  def current_count(magazine)
    if id.present?
      product_item_counts.create(magazine_id: magazine.id, count: 0) if product_item_counts.where(magazine_id: magazine.id).blank?
    end
    product_item_counts.present? ? product_item_counts.where(magazine_id: magazine.id).last.count : 0
  end

  def default_create_product_item_count
    Magazine.all.map{|magaz| ProductItemCount.create({product_item_id: id, magazine_id: magaz.id, count: 0}) }
  end

  # def total_sum

  # end
end
