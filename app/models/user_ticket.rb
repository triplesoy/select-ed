class UserTicket < ApplicationRecord
  belongs_to :user
  belongs_to :ticket
  has_one_attached :qrcode
end
