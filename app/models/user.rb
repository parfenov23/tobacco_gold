class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
  :registerable,
  :recoverable,
  :rememberable,
  :trackable,
  :validatable

  validates :login, :email, presence: true
  validates :login, :email, uniqueness: true

  has_many :sales
  has_many :contacts
  has_many :manager_payments

  def title
    login
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
    (sales.sum(:price) / 100 * meneger_procent).to_i - manager_payments.sum(:price)
  end

  def meneger_procent
    procent_sale
  end
end
