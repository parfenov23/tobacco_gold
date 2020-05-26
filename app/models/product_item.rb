require 'carrierwave/orm/activerecord'
class ProductItem < ActiveRecord::Base
  require 'string/similarity'
  include PgSearch
  pg_search_scope :search,
  :against => [:title, :barcode],
  :using => {
    :tsearch => {:normalization => 2, :negation => true},
    :dmetaphone => {},
    :trigram => {
      :threshold => 0.2
    }
  }

  pg_search_scope :search_everywhere, 
  against: [:title, :barcode],
  using: {
    tsearch: {
      dictionary: 'russian',
      prefix: true
    },
    trigram: {
      threshold: 0.2
    }
  }


  belongs_to :product
  has_many :buy_items, dependent: :destroy
  has_many :product_item_magazine_prices, dependent: :destroy
  has_many :sale_items, dependent: :destroy
  has_many :product_item_top_magazines
  has_and_belongs_to_many :tags
  # default_scope { order('title ASC') }
  scope :total_sum, -> { map{|pi| pi.product.current_price}.sum }
  has_many :product_item_counts, dependent: :destroy
  after_create :default_create_product_item_count
  # after_update :get_image_url
  default_scope { where(archive: false) }

  mount_uploader :image_url, ImageUrlUploader

  def self.popular_sort(count_first=3)
  	products = self.all
  	products.find(
  		products.map{ |m| 
  			[m.id, m.sale_items.count] 
      }.to_h.sort_by(&:last).reverse.first(count_first).to_h.keys)
  end

  def self.all_company(company)
    where(product_id: company.products.ids)
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
    product.company.magazines.map{|magaz| ProductItemCount.create({product_item_id: id, magazine_id: magaz.id, count: 0}) }
  end

  def must_be_ordered(deff_count_stock, magazine)
    p1 = sale_items.where(["created_at >= ?", (Time.now - 2.week).beginning_of_day]).
    where(["created_at <= ?", (Time.now - 1.week).end_of_day]).sum(:count)
    p2 = sale_items.where(["created_at >= ?", (Time.now - 1.week).beginning_of_day]).sum(:count)
    current_count_stock = current_count(magazine)
    change_sale = p2 - p1
    to_order = (change_sale + deff_count_stock ) < deff_count_stock ? deff_count_stock : (change_sale + deff_count_stock ) - current_count_stock
    to_order < 0 ? 0 : to_order
  end

  def self.accurate_search_title(query, procent=0.8)
    result = title_search(query).first
    if result.present?
      reg = Regexp.new "\([А-я].+?\)"
      r_title = result.title.gsub(reg, "").gsub("(", "").gsub(")", "")
      result = String::Similarity.cosine(r_title, query) > procent ? result : nil
    end
    result
  end

  def get_description
    description.present? ? "#{product.title}(#{title}) - #{description}" : "Нет описания"
  end

  def self.all_present(magazine_id, type=true)
    joins(:product_item_counts).where(["product_item_counts.magazine_id = ? AND product_item_counts.count #{type ? '>' : '<='} ?", magazine_id, 0]).uniq
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

  def self.search_title_or_barcode(company_id, title)
    ids_products = Product.where(company_id: company_id).ids
    ProductItem.where(product_id: ids_products).where("similarity(barcode, ?) > 0.1 OR similarity(title, ?) > 0.2", title, title)
  end

  def product_title
    product.title
  end

  def default_img
    # image_url.present? ? image_url.to_s : (product.default_img rescue nil)
    image_url.to_s
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

  def get_image_url
    base64 = image_url
    dir_fold = "#{Rails.root.to_s}/public"
    dir_url = "/system/attachment/product_items"
    dir_path = dir_fold + dir_url
    img_url = "/#{id}.png"
    public_url = dir_url+img_url
    if (base64.to_s.scan("http://").present? || base64.to_s.scan("https://").present? )
      img = (open(base64) rescue nil)
      base64 = Base64.encode64(img.present? ? img.read.to_s : "")
    end

    if (base64.present? && base64.to_s.scan("/attachment/").blank?)
      base64 = base64.gsub("data:image/png;base64,", "").gsub("data:image/jpeg;base64,", "")
      FileUtils.mkdir_p(dir_path) unless File.directory?(dir_path)
      File.open((dir_path+img_url), 'wb') do|f|
        f.write(Base64.decode64(base64))
      end
      update(image_url: public_url)
    end
    public_url
  end

  def transfer_to_json(api_key=nil)
    $api_key = api_key if api_key.present?
    as_json({
      except: [:created_at, :updated_at, :image_url, :price_id],
      methods: [:count, :magazine_count, :count_sales, :default_img, :default_price, :product_title]
    })
  end

  def self.transfer_to_json(api_key=nil)
    $api_key = api_key if api_key.present?
    all.map{|pi| pi.transfer_to_json(api_key)}
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

  def default_price
    price.present? ? price.price : product.current_price
  end

  def self.text_search(query, val = "0.4")
    search(query).where("similarity(title, ?) > #{val}", query).order("similarity(title, #{ActiveRecord::Base.connection.quote(query)}) DESC")
  end

  def self.full_text_search(query)
    arr_search = [query.mb_chars.downcase.to_s, query.mb_chars.capitalize.to_s, query.mb_chars.upcase.to_s]
    ids_search = search_everywhere(arr_search[0]).ids
    ids_search += search_everywhere(arr_search[1]).ids
    ids_search += search_everywhere(arr_search[2]).ids

    ids_search += where(arr_search.map{|i| "title ~* '#{i}'"}.join(" AND ")).ids
    where(id: ids_search.uniq)
  end

  def company_id
    product.company_id
  end

  def price(api_key=nil)
    $api_key = api_key if api_key.present?
    magazine_id = $api_key.present? ? (Magazine.where(api_key: $api_key).last.id rescue nil) : nil
    (product.product_prices.where(id: price_id(magazine_id)).last rescue nil) || product.current_price_model
  end

  def price_id(magazine_id=nil, params=nil)
    if params.blank?
      curr_price = product_item_magazine_prices.find_by_magazine_id(magazine_id) if magazine_id.present?
      curr_price.present? ? curr_price.price_id : product.current_price_model.id
    else
      product_item_magazine_prices.create(params).price_id
    end
  end

  def current_price(contact)
    contact.current_price_item(self)
  end

end
