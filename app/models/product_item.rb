class ProductItem < ActiveRecord::Base
  require 'string/similarity'
  include PgSearch
  pg_search_scope :search,
  :against => :title,
  :using => {
    :tsearch => {:normalization => 2, :negation => true},
    :dmetaphone => {},
    :trigram => {
      :threshold => 0.2
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

  def last_buy_price
    (buy_items.last.price rescue product.min_price)
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

  def self.accurate_search_title(query)
    result = title_search(query).first
    if result.present?
      reg = Regexp.new "\([А-я].+?\)"
      r_title = result.title.gsub(reg, "").gsub("(", "").gsub(")", "")
      result = String::Similarity.cosine(r_title, query) > 0.8 ? result : nil
    end
    result
  end

  def self.all_present(magazine_id, type=true)
    joins(:product_item_counts).where("product_item_counts.magazine_id"=> magazine_id).where(["product_item_counts.count #{type ? '>' : '<='} ?", 0]).uniq
  end

  # def as_json(*)
  #   super.except("created_at", "updated_at").tap do |hash|
  #     hash["default_img"] = image_url.present? ? image_url : (product.default_img rescue nil)
  #     hash["count_sales"] = sale_items.count
  #     # hash["product"] = product.as_json
  #     hash["count"] = product_item_counts.sum(:count)
  #     hash["magazine_count"] = product_item_counts.map{|pic| {id: pic.magazine_id, count: pic.count}}
  #   end
  # end

  def default_img
    image_url.present? ? image_url : (product.default_img rescue nil)
  end

  def count
    product_item_counts.sum(:count)
  end

  def magazine_count
    product_item_counts.map{|pic| {id: pic.magazine_id, count: pic.count}}
  end

  def count_sales
    sale_items.count
  end

  def transfer_to_json
    as_json({
      except: [:created_at, :updated_at],
      methods: [:default_img, :count, :magazine_count, :products, :count_sales]
      })
  end

  def self.transfer_to_json
    all.map(&:transfer_to_json)
  end

  def self.title_search(query)
    result = nil
    count = 6
    count.times do |i|
      result = text_search(query, ((count-i)*0.1).to_s )
      break if result.present?
    end
    result
  end

  def self.text_search(query, val = "0.4")
    search(query).where("similarity(title, ?) > #{val}", query).order("similarity(title, #{ActiveRecord::Base.connection.quote(query)}) DESC")
  end

end
