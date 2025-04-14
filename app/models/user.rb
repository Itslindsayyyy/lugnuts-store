class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :wishlist_items, dependent: :destroy
  has_many :wishlist_products, through: :wishlist_items, source: :product
  has_one :cart, dependent: :destroy
  has_many :orders

  # Enum for roles
  enum :role, { customer: 0, manager: 1, admin: 2 }

  # ✅ Set default role
  after_initialize :set_default_role, if: :new_record?

  def set_default_role
    self.role ||= :customer
  end
end
