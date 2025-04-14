class Product < ApplicationRecord
    belongs_to :category, optional: true
    has_and_belongs_to_many :tags

    has_many :wishlist_items, dependent: :destroy
    has_many :wishlisted_by_users, through: :wishlist_items, source: :user

    # validations
    validates :name, :price, :category_id, :image_url, presence: true
end
