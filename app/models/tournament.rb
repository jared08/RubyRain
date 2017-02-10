class Tournament < ApplicationRecord
  has_many :player_tournaments
  has_many :stocks, through: :player_tournaments

  store :tournament_info, accessors: [ ], coder: JSON
end
