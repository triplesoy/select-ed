class Community < ApplicationRecord
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
  validates :is_public, presence: true
  validates :is_visible, presence: true
  validates :title, uniqueness: true
end
