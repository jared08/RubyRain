class Tournament < ApplicationRecord
  has_many :golfer_tournaments
  has_many :golfer, through: :golfer_tournaments

  self.per_page = 1
end
