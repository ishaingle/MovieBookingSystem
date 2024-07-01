class Booking < ApplicationRecord
  belongs_to :showtime
  belongs_to :user
  validates :seat_number, uniqueness: { scope: :showtime_id }
end
