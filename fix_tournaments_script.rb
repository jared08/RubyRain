temp = Tournament.all

for t in temp
  t[:TournamentID] = t[:tournament_info]["TournamentID"]
  t[:Name] = t[:tournament_info]["Name"]
  t[:StartDate] = t[:tournament_info]["StartDate"]
  t[:EndDate] = t[:tournament_info]["EndDate"]
  t[:IsOver] = t[:tournament_info]["IsOver"]
  t[:IsInProgress] = t[:tournament_info]["IsInProgress"]
  t[:Venue] = t[:tournament_info]["Venue"]
  t[:Location] = t[:tournament_info]["Location"]
  t[:Par] = t[:tournament_info]["Par"]
  t[:Yards] = t[:tournament_info]["Yards"]
  t[:Purse] = t[:tournament_info]["Purse"]
  t.save
end
