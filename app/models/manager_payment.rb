class ManagerPayment < ActiveRecord::Base
  belongs_to :user

  def self.curr_month_price
    start_day = (Time.now - Time.new.day.day + 1.day).beginning_of_day
    all_others = where(["created_at > ?", start_day]).where(payment: true)
    all_others.sum(:price)
  end

  def self.curr_day_price
    start_day = Time.now.beginning_of_day
    where(["created_at > ?", start_day]).where(payment: true).sum(:price)
  end

  def self.curr_year_price
    start_day = Time.now.beginning_of_year
    where(["created_at > ?", start_day]).where(payment: true).sum(:price)
  end
end
