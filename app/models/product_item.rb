class ProductItem < ActiveRecord::Base
  belongs_to :product
  has_many :buy_items, dependent: :destroy
  has_many :sale_items, dependent: :destroy
  default_scope { order('title ASC') }
  scope :total_sum, -> { map{|pi| pi.product.current_price}.sum }

  def self.popular_sort(count_first=3)
  	products = self.all
  	products.find(
  		products.map{ |m| 
  			[m.id, m.sale_items.count] 
  		}.to_h.sort_by(&:last).reverse.first(count_first).to_h.keys)
  end

  # def total_sum

  # end
end
