class Tournament < ApplicationRecord
  has_many :golfer_tournaments
  has_many :golfer, through: :golfer_tournaments

  store :tournament_info, accessors: [ ], coder: JSON
end
