class Community < ApplicationRecord
  belongs_to :user
  has_many :events
  has_many :community_users
  has_many :users, through: :community_users
  has_many :community_join_requests
  has_many :users, through: :community_join_requests

  validates :title, presence: true
  validates :description, presence: true
  validates :category, presence: true
  validates :country, presence: true
  validates :city, presence: true
  validates :title, uniqueness: true
  validates :photos, presence: true

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
