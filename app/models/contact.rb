class Contact < ActiveRecord::Base
  has_many :orders, dependent: :destroy

  def title
    first_name
  end

  def self.first_url
    "contacts"
  end
end
