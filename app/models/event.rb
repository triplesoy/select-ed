class Event < ApplicationRecord
  belongs_to :community
  has_many :tickets
  has_many :users, through: :tickets
  has_many :event_rsvps
  has_many :users, through: :event_rsvps
end
