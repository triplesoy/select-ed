class Community < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :community_owner, class_name: 'User', foreign_key: 'user_id'


  has_many :events, dependent: :destroy
  has_many :tickets, through: :events
  has_many :user_tickets, through: :tickets
  has_many :community_users
  has_many :members, through: :community_users, source: :user
  has_many :community_join_requests, dependent: :destroy
  has_many :join_request_users, through: :community_join_requests, source: :user

  validates :title, presence: true, uniqueness: { case_sensitive: false }
  validates :description, presence: true, length: { minimum: 20, maximum: 1000 }
  validates :short_description, presence: true, length: { minimum: 8, maximum: 100 }
  validates :category, presence: true
  validates :country, presence: true
  validates :city, presence: true
  validates :is_visible, inclusion: { in: [true, false] }
  validate :photos_presence

  validates :instagram_handle_main, format: { with: /\A[a-z0-9_.]{1,30}\Z/i, message: "is not a valid Instagram handle" }, allow_blank: true
  validates :instagram_handle_members, format: { with: /\A[a-z0-9_.]{1,30}\Z/i, message: "is not a valid Instagram handle" }, allow_blank: true

  before_validation :sanitize_instagram_handle_main
  before_validation :sanitize_instagram_handle_members

  has_many_attached :photos
  has_one_attached :video

  def owner
    # Find the community user with role 'admin'
    community_user = self.community_users.find_by(role: 'admin')

    # If no such user exists, raise an exception
    raise "No admin exists for Community ##{id}" unless community_user.present?

    # Otherwise, return the corresponding user
    community_user.user
  end



  def pending_community_join_requests
    community_join_requests.where(status: "pending")
  end

  def moderator
    community_users.where(role: "moderator")
  end

  def youtube_banner=(url)
    if url.blank?
      super(nil)
    else
      regex = /(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})/
      video_id = url.match(regex)[1]
      embed_url = "https://www.youtube.com/embed/#{video_id}?autoplay=1&controls=0&mute=1&showinfo=0&loop=1&rel=0&disablekb=0&controls=0"
      super(embed_url)
    end
  end

  private

  def sanitize_instagram_handle_main
    uri = URI.parse(instagram_handle_main)
    self.instagram_handle_main = uri.path.gsub('/', '') if uri.host&.include?('instagram.com')
  rescue URI::InvalidURIError
  end

  def sanitize_instagram_handle_members
    uri = URI.parse(instagram_handle_members)
    self.instagram_handle_members = uri.path.gsub('/', '') if uri.host&.include?('instagram.com')
  rescue URI::InvalidURIError
  end

  def photos_presence
    errors.add(:photos, "can't be blank") unless photos.attached?
  end
end
