class Ticket < ApplicationRecord
  validates :model, inclusion: { in: %w(free regular vip),
    message: "%{value} is not a valid ticket model" }
  belongs_to :event
  has_many :user_tickets
end
