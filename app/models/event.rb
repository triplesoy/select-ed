class Event < ApplicationRecord
  belongs_to :community
  belongs_to :user
  has_many :tickets
  has_many :users, through: :tickets
  has_many_attached :photos
  has_one_attached :video

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
end
