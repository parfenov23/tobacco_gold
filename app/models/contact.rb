class Contact < ActiveRecord::Base
  has_many :orders, dependent: :destroy
  has_many :sales
  has_many :contact_prices, dependent: :destroy
  belongs_to :user, dependent: :destroy

  include PgSearch
  pg_search_scope :search,
  :against => [:phone, :first_name],
  :using => {
    :tsearch => {:normalization => 1, :negation => true},
    :trigram => {
      :threshold => 0.5
    }
  }

  # validates :phone, presence: true
  # validates :phone, uniqueness: true

  def title
    first_name
  end

  # def current_price_item(item)
  #   item_product = item.product
  #   if item.price_id.blank?
  #     opt ? item_product.current_price : item_product.current_price_opt
  #   else
  #     item.price.price
  #   end
  # end

  def self.first_url
    "contacts"
  end

  def email
    user.present? ? user.email : nil
  end

  def current_cashback
    curr_time = Time.now - 1.month
    all_sum_price = sales.where(["created_at > ? AND created_at < ?", curr_time.beginning_of_month, curr_time.end_of_month]).sum(:price)
    curr_proc = cashback + (all_sum_price/1500).floor
    curr_proc
  end

  def current_price_item(item)
    if item.default_price.blank?
      contact_price = find_contact_price(item)
      contact_price.present? ? contact_price[:price] : ((!opt rescue true) ? item.product.current_price : item.product.current_price_opt)
    else
      item.default_price
    end
  end

  def find_contact_price(item)
    all_contact_prices.select{|k| k[:product_id] == item.product_id}.last
  end

  def all_contact_prices
    contact_prices.map{|contact_price| {product_id: contact_price.product_id, price: contact_price.product_price.price}}
  end

  def transfer_to_json
    as_json({
      except: [:created_at, :updated_at],
      methods: [:all_contact_prices]
      })
  end
end
