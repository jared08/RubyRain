#should run every monday morning

players = Stock.where(sport: "Golf") #need the stock as well as the golfer to get access to name and api specific id

tournament = Tournament.find_by(index: Rails.application.config.current_tournament_index)
tournament[:IsOver] = true
tournament[:IsInProgress] = false
tournament.save
puts(tournament[:Name])

for player in players 
  golfer = Golfer.find_by(stock_id: player.id)
  gt = GolferTournament.where("golfer_id = ? AND tournament_id = ?", golfer.id, tournament.id)
  if (gt.empty?)
    puts(player[:name].to_s + " did not play in " + tournament[:Name])
  else
    puts(player[:name].to_s + " played in " + tournament[:Name])

    uri = URI('https://api.fantasydata.net/golf/v2/json/PlayerTournamentStatsByPlayer/' + tournament[:TournamentID].to_s + '/' + 
     player[:player_info]["PlayerID"].to_s)

    puts(uri)

    request = Net::HTTP::Get.new(uri.request_uri)
    request['Ocp-Apim-Subscription-Key'] = '34380396ef994539b30aa22ac1759ffb'
    request.body = "{body}"

    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(request)
    end

    if (response.body != '') #returns blank if the player didn't play in the tournament
      info = JSON.parse(response.body)

      golfer_tournament = golfer.golfer_tournaments.create()
      golfer_tournament[:tournament_id] = tournament[:id]

      golfer_tournament[:Rank] = info["Rank"]
      golfer_tournament[:TotalScore] = info["TotalScore"]
      golfer_tournament[:Earnings] = info["Earnings"]

      golfer_tournament.save
       
      if (info["Rank"] != 'nil') #can switch to MadeCut when data isn't scrambled
        puts(info["Rank"])

        golfer[:made_cut] = golfer[:made_cut] + 1
        earnings = 2
        if (info["Rank"].to_i < 25)
          golfer[:top_twenty_five] = golfer[:top_twenty_five] + 1
          earnings = earnings + 3
        end
        if (info["Rank"].to_i < 10)
          golfer[:top_ten] = golfer[:top_ten] + 1
          earnings = earnings + 5
        end
        if (info["Rank"].to_i == 1)
          golfer[:first] = golfer[:first] + 1
          earnings = earnings + 15 
        elsif (info["Rank"].to_i == 2)
          golfer[:second] = golfer[:second] + 1
          earnings = earnings + 8
        elsif (info["Rank"].to_i == 3)
          golfer[:third] = golfer[:third] + 1
          earnings = earnings + 4
        end
        golfer.save
        player[:earnings] = player[:earnings] + earnings
        player.save
      else
        puts('MISSED CUT')
        puts(info)
      end
    else
     puts('DID NOT PLAY')
    end

  end 
end
