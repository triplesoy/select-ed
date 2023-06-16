class User < ApplicationRecord
  has_many :tickets
  has_many :events
  has_many :event_rsvps
  has_many :my_events, through: :event_rsvps, source: :event
  has_many :communities
  has_many :community_users
  has_many :community_join_requests
  has_many :my_communities, through: :community_join_requests, source: :community
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :avatar

  def has_rsvp_with_event?(event)
    self.event_rsvps.any? { |rsvp| rsvp.event == event }
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def is_member_of?(community)
    self.community_users.any? { |cu| cu.community == community }
  end

  def is_moderator_of?(community)
    self.community_users.any? { |cu| cu.community == community && cu.role == "moderator" }
  end

  def role_of_this(community)
    return "owner" if community.user == self

    self.community_users.find_by(community: community).role
  end
end
