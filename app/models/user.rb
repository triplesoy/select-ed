class User < ApplicationRecord
  has_many :tickets
  has_many :events
  has_many :user_tickets
  has_many :my_events, through: :user_tickets, source: :event
  has_many :communities
  has_many :community_users
  has_many :community_join_requests
  has_many :my_communities, through: :community_join_requests, source: :community
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :avatar

  # validates :first_name, presence: true
  # validates :last_name, presence: true
  # validates :birthdate, presence: true
  # validates :address, presence: true
  # validates :country, presence: true
  # validates :instagram_handle, presence: true
  # validates :occupation, presence: true

  def has_ticket_with_event?(event)
    self.user_tickets.any? { |ticket| ticket.event == event }
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

  def is_admin_of?(community)
    self.community_users.any? { |cu| cu.community == community && cu.role == "admin" }
  end

  def role_of_this(community)
    return "owner" if community.user == self
    self.community_users.find_by(community: community).role if self.community_users.find_by(community: community)
  end

  def events_going_to
    user_tickets.map(&:ticket).map(&:event)
  end
end
