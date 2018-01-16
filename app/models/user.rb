class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
  :registerable,
  :recoverable,
  :rememberable,
  :trackable,
  :validatable

  validates :email, presence: true
  validates :email, uniqueness: true

  has_many :sales
  has_many :contacts
  has_many :manager_payments
  belongs_to :magazine
  belongs_to :contact

  def title
    email
  end

  def self.first_url
    "users"
  end

  def is_admin?
    role == "admin"
  end

  def is_manager?
    role == "manager"
  end

  def is_user?
    role == "user"
  end

  def balance_payments
    manager_payments.sum(:price) - manager_payments.where(payment: true).sum(:price)
  end

  def meneger_procent
    procent_sale
  end

  # Баланс
  def manager_balance_month
    manager_payments.where(["created_at > ?", Time.now.beginning_of_month]).where(["created_at < ?", Time.now.end_of_month]).sum(:price)
  end

  def manager_balance_today
    manager_payments.where(["created_at > ?", Time.now.beginning_of_day]).where(["created_at < ?", Time.now.end_of_day]).sum(:price)
  end

  # Средний Чек
  def manager_average_check_today
    all_sales = sales.where(["created_at > ?", Time.now.beginning_of_day]).where(["created_at < ?", Time.now.end_of_day])
    all_sales.count > 0 ? all_sales.sum(:price) / all_sales.count : 0
  end

  def manager_average_check_month
    all_sales = sales.where(["created_at > ?", Time.now.beginning_of_month]).where(["created_at < ?", Time.now.end_of_month])
    all_sales.count > 0 ? all_sales.sum(:price) / all_sales.count : 0
  end

  def manager_average_check_all
    sales.count > 0 ? sales.sum(:price) / sales.count : 0
  end

  def manager_payment_month
    sales.where(["created_at > ?", Time.now.beginning_of_month]).where(["created_at < ?", Time.now.end_of_month])
  end

  def manager_payment_today
    sales.where(["created_at > ?", Time.now.beginning_of_day]).where(["created_at < ?", Time.now.end_of_day])
  end
end
