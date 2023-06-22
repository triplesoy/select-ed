class Event < ApplicationRecord
  belongs_to :community
  belongs_to :user
  has_many :tickets
  has_many :user_tickets, through: :tickets
  has_many :users, through: :user_tickets, source: :user
  has_many_attached :photos
  has_one_attached :video

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
  validates :start_time, :end_time, presence: true

  def participants
    user_tickets
  end

  def tickets_released
(    tickets.sum(:quantity) +     user_tickets.count)
  end

  def total_tickets
    tickets.sum(:quantity)
  end

  def total_tickets_sold
    user_tickets.count
  end

  def total_tickets_accepted
    user_tickets.where(scanned: "accepted").count
  end

  def total_tickets_rejected
    user_tickets.where(scanned: "rejected").count
  end
end
