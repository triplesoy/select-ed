class Community < ApplicationRecord
  belongs_to :user
  has_many :events
  has_many :community_users
  has_many :users, through: :community_users
  has_many :community_join_requests
  has_many :users, through: :community_join_requests

  validates :title, presence: true, on: :create
  validates :description, presence: true, on: :create
  validates :category, presence: true, on: :create
  validates :country, presence: true, on: :create
  validates :city, presence: true, on: :create
  validates :title, uniqueness: true, on: :create
  # validates :photos, presence: true, on: :create
  validates :is_visible, presence: true, on: :create

  has_many :events, dependent: :destroy
  has_many_attached :photos
  has_one_attached :video


  def pending_community_join_requests
    CommunityJoinRequest.where(community: self, status: "pending")
  end

  def moderator
    self.community_users.where(role: "moderator")
  end
end
