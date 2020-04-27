class Tag < ActiveRecord::Base
  include PgSearch
  has_and_belongs_to_many :product_items
  pg_search_scope :search_everywhere, against: [:title]

  def self.search_title(company_id, title)
    Tag.where(company_id: company_id).search_everywhere(title)
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
