class ContactMessage < ApplicationRecord
    validates :name, presence: true
    validates :email, presence: true, format: { with: /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/, message: "must be a valid email address" }
    validates :subject, presence: true
    validates :message, presence: true, length: { minimum: 10 }
end
