class UserTicket < ApplicationRecord
  validates :scanned, inclusion: { in: %w(accepted pending rejected),
    message: "%{value} is not a valid status" }
  belongs_to :user
  belongs_to :ticket
  has_one_attached :qrcode
end
