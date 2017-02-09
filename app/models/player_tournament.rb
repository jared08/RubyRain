class PlayerTournament < ApplicationRecord
  belongs_to :stock
  belongs_to :tournament
  
  store :player_tournament_info, accessors: [ ], coder: JSON
end
