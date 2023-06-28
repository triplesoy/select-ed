class Community < ApplicationRecord

  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :user
  has_many :events, dependent: :destroy
  has_many :tickets, through: :events
  has_many :user_tickets, through: :tickets
  has_many :community_users
  has_many :members, through: :community_users, source: :user
  has_many :community_join_requests, dependent: :destroy
  has_many :join_request_users, through: :community_join_requests, source: :user




  validates :title, presence: true, on: :create
  validates :description, presence: true, on: :create, length: { minimum: 20 }
  validates :short_description, presence: true, on: :create, length: { minimum: 10 }

  validates :category, presence: true, on: :create
  validates :country, presence: true, on: :create
  validates :city, presence: true, on: :create
  validates :title, uniqueness: { case_sensitive: false }, on: :create
  # validates :photos, presence: true, on: :create
  validates :is_visible, presence: true, on: :create
  validate :photos_presence


  has_many_attached :photos
  has_one_attached :video


  def pending_community_join_requests
    community_join_requests.where(status: "pending")
  end

  def moderator
    self.community_users.where(role: "moderator")
  end
end

private

def photos_presence
  errors.add(:photos, "can't be blank") unless photos.attached?
end
