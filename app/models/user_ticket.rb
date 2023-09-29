class UserTicket < ApplicationRecord
  # attr_accessor :qr_full_name, :qr_email

  validates :scanned, inclusion: { in: %w(accepted pending rejected),message: "%{value} is not a valid status" }
  validates :user_id, uniqueness: { scope: :ticket_id, message: "You already have a ticket for this event" }, if: -> { user_id.present? }

  # validates :qr_full_name, presence: true, format: { with: /\A[a-zA-Z ]+\z/, message: "only allows letters" }, length: { maximum: 50 }
  # validates :qr_email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :ticket_id, presence: true


  belongs_to :user, optional: true
  belongs_to :ticket

  has_one_attached :photo
  has_one_attached :qrcode


  def has_expired?
    expiration_time = ticket.expire_time + 6.hours
    expiration_time.present? && expiration_time < DateTime.now
  end
end
