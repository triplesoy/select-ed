class CommunityUser < ApplicationRecord
  belongs_to :user
  belongs_to :community

  validates :role, presence: true
  validates :community, presence: true
  validates :user, uniqueness: { scope: :community }
end
