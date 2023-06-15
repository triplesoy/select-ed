class EventRsvp < ApplicationRecord
  validates :status, inclusion: { in: %w(accepted pending rejected),
    message: "%{value} is not a valid status" }
  belongs_to :user
  belongs_to :event
end
