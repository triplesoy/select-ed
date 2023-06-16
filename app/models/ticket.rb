class Ticket < ApplicationRecord
  validates :model, inclusion: { in: %w(free regular vip),
    message: "%{value} is not a valid ticket type" }
  belongs_to :event
  has_many :user_tickets
  has_many :users, through: :user_tickets
end
