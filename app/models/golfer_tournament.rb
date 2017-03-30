class GolferTournament < ApplicationRecord
  belongs_to :golfer
  belongs_to :tournament
end
