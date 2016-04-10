class Buy < ActiveRecord::Base
  has_many :buy_items

  def self.all_sum
    sum(:price)
  end
end
