class Contact < ActiveRecord::Base
  has_many :orders, dependent: :destroy
  has_many :sales

  validates :phone, presence: true
  validates :phone, uniqueness: true

  def title
    first_name
  end

  def self.first_url
    "contacts"
  end
end
