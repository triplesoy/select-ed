class CommunityJoinRequest < ApplicationRecord
  belongs_to :user
  belongs_to :community
  has_many :notifications, as: :recipient, dependent: :destroy



end
