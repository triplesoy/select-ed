class Ticket < ApplicationRecord
  validates :model, inclusion: { in: %w(free regular vip),
    message: "%{value} is not a valid ticket model" }
  belongs_to :event
  has_many :user_tickets
  has_many :users, through: :user_tickets
  validates :quantity, presence: true

  def sold_tickets(event)
    event.user_tickets.select{ |user_ticket| user_ticket.ticket.model == self.model }.count
  end

end
