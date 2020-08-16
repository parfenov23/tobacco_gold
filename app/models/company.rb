class Company < ActiveRecord::Base
  has_many :magazines, dependent: :destroy
  has_many :providers, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :contacts, dependent: :destroy
  has_many :order_requests, dependent: :destroy
  has_many :transfers, dependent: :destroy

  def self.first_url
    "company"
  end

  def demo_sign_in_time
    demo_time.present? ? (demo_time.to_time.end_of_day > Time.now) : true
  end
end
