class Ticket < ApplicationRecord
  belongs_to :users
  belongs_to :events
end
