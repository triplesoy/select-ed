class User < ApplicationRecord
  COUNTRIES = ['United States', 'France', 'Portugal']

  has_many :tickets
  has_many :events
  has_many :communities
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
