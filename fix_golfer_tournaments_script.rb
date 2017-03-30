temp = GolferTournament.all

for t in temp
  t[:Rank] = t[:golfer_tournament_info]["Rank"]
  t[:TotalScore] = t[:golfer_tournament_info]["TotalScore"]
  t[:Earnings] = t[:golfer_tournament_info]["Earnings"]
  t.save
end
