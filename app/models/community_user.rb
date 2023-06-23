class CommunityUser < ApplicationRecord
  belongs_to :user
  belongs_to :community

  validates :role, presence: true
  validates :community, presence: true
  validates :user, uniqueness: { scope: :community }

  def events_attended(community)
    community.events.select do |event|
      event.user_tickets.where(user: self.user).exists?
    end
  end
end
