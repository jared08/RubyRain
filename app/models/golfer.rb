class Golfer < ApplicationRecord
  belongs_to :stock

  has_many :golfer_tournaments
  has_many :tournaments, through: :golfer_tournaments
end
