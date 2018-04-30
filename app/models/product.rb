class Product < ActiveRecord::Base
  has_many :product_items, dependent: :destroy
  has_many :product_prices, dependent: :destroy
  belongs_to :category
  default_scope { order("title ASC") }

  def self.first_url
    "products"
  end

  def min_price
    items_ids = product_items.ids
    buy_items = BuyItem.where(id: items_ids).where(["price > ?", 50])
    buy_items.present? ? buy_items.minimum(:price) : product_prices.minimum(:price)
  end

  def self.stock_price(magazine)
    result = 0
    all.each do |product|
      pi_count = product.product_items.inject(0){|sum, pi| sum + pi.current_count(magazine) }
      result += (product.current_price * pi_count )
    end
    result
  end

  def self.all_present(magazine_id)
    joins(product_items: :product_item_counts).where(product_item_counts: {magazine_id: magazine_id}).where("product_item_counts.count > 0").uniq
  end

  def current_price
    price = product_prices.find_by_default(true)
    (price.price rescue product_prices.minimum(:price)).to_i
  end

  def current_price_opt
    price = product_prices.find_by_opt(true)
    (price.price rescue current_price).to_i
  end

  def current_price_model
    product_prices.find_by_default(true)
  end

  def current_price_opt_model
    price =  product_prices.find_by_opt(true)
    price.present? ? price : current_price_model
  end

  def current_purchase_price(provider_id)
    Provider.find(provider_id).provider_items.where(product_id: id).last.price rescue 0
  end

  def as_json(*)
    super.except("created_at", "updated_at").tap do |hash|
      hash["current_price"] = current_price
      hash["current_price_opt"] = current_price_opt
    end
  end

  def transfer_to_json
    as_json({
      except: [:created_at, :updated_at]
      })
  end

  def self.transfer_to_json
    all.map(&:transfer_to_json)
  end
end
