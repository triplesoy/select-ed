class User < ApplicationRecord

  has_many :tickets
  has_many :events
  has_many :event_rsvps
  has_many :going_events, through: :event_rsvps, source: :event
  has_many :communities
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :avatar

  def full_name
    "#{first_name} #{last_name}"
  end


end
