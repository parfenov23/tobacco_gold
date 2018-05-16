class ManagerPayment < ActiveRecord::Base
  belongs_to :user

  def self.curr_month_price
    start_day = (Time.now - Time.new.day.day + 1.day).beginning_of_day
    all_others = where(["updated_at > ?", start_day]).where(payment: true)
    all_others.sum(:price)
  end
  
  def self.curr_day_price
    start_day = Time.now.beginning_of_day
    where(["updated_at > ?", start_day]).where(payment: true).sum(:price)
  end

  def self.curr_year_price(type="year")
    start_day = type == "year" ? Time.now.beginning_of_year : (Time.now - 1.year).beginning_of_year
    end_day = type == "last_year" ? Time.now.beginning_of_year : Time.now
    where(["updated_at > ?", start_day]).where(["updated_at <= ?", end_day]).where(payment: true).sum(:price)
  end
end
