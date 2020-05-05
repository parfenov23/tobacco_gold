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
  has_many :manager_shifts
  belongs_to :magazine
  belongs_to :contact

  def title
    email
  end

  def self.first_url
    "users"
  end

  def api_url
    Rails.env.production? ? "http://crm-stock.ru" : "http://localhost:3000"
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
    manager_payments.where(payment: false).sum(:price)
  end

  def meneger_procent
    procent_sale
  end

  def get_api_key
    update(api_key: SecureRandom.hex(16)) if api_key.blank?
    api_key
  end

  def manager_shifts_open
    manager_shifts.where(status: "open")
  end

  # Баланс
  def manager_balance_month
    manager_payments.where(["created_at > ?", Time.now.beginning_of_month]).where(["created_at < ?", Time.now.end_of_month]).sum(:price)
  end

  def manager_balance_today
    manager_payments.where(["created_at > ?", Time.now.beginning_of_day]).where(["created_at < ?", Time.now.end_of_day]).sum(:price)
  end

  def manager_payment_cash(type_cash='cash')
    all_manager_pay = manager_payments.where(payment: false)
    current_cashbox = magazine.cashbox
    current_cashbox.calculation(type_cash, balance_payments, false)
    all_manager_pay.update_all(payment: true)
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

  def transfer_to_json
    as_json({
      except: [:created_at, :updated_at, :encrypted_password, :reset_password_token, :reset_password_sent_at]
      })
  end

end
