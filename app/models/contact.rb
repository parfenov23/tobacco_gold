class Contact < ActiveRecord::Base
  has_many :orders, dependent: :destroy
  has_many :sales
  has_one :user, dependent: :destroy

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
end
