class Showtime < ApplicationRecord
  belongs_to :movie
  has_many :bookings, dependent: :destroy

  validates :available_seats, numericality: { greater_than_or_equal_to: 0 }
end
