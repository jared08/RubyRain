class Tournament < ApplicationRecord
  has_many :golfer_tournaments
  has_many :golfer, through: :golfer_tournaments
end
