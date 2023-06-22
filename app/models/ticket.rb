class Ticket < ApplicationRecord
  validates :model, inclusion: { in: %w(free regular vip),
    message: "%{value} is not a valid ticket model" }
  belongs_to :event
  has_many :user_tickets
  has_many :users, through: :user_tickets

  def ticket_counter(event)
    vip_ticket = se
  end
end
