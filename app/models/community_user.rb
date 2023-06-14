class CommunityUser < ApplicationRecord
  belongs_to :user
  belongs_to :community

  enum role: { member: 0, moderator: 1, admin: 2 }


end
