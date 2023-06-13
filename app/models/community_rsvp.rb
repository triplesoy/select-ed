class CommunityRsvp < ApplicationRecord
  belongs_to :users
  belongs_to :communities
end
