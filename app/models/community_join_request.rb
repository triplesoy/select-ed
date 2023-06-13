class CommunityJoinRequest < ApplicationRecord
  belongs_to :users
  belongs_to :communities
end
