class GolferTournament < ApplicationRecord
  belongs_to :golfer
  belongs_to :tournament
  
  store :golfer_tournament_info, accessors: [ ], coder: JSON
end
