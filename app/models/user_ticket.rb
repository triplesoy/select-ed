class UserTicket < ApplicationRecord
  validates :scanned, inclusion: { in: %w(accepted pending rejected),
    message: "%{value} is not a valid status" }
  validates :user_id, uniqueness: { scope: :ticket_id, message: "You already have a ticket for this event" }
  belongs_to :user
  belongs_to :ticket
  has_one_attached :photo
  has_one_attached :qrcode
end
