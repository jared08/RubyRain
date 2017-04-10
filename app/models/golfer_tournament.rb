class GolferTournament < ApplicationRecord
  belongs_to :golfer
  belongs_to :tournament
  self.per_page = 10
end
