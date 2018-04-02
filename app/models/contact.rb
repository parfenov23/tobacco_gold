class Contact < ActiveRecord::Base
  has_many :orders, dependent: :destroy
  has_many :sales
  has_many :contact_prices, dependent: :destroy
  has_one :user, dependent: :destroy

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

  def self.first_url
    "contacts"
  end

  def email
    user.present? ? user.email : nil
  end

  def transfer_to_json
    as_json({
      except: [:created_at, :updated_at],
      include: [:contact_prices]
      })
  end
end
