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

  def title
    email
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
end
