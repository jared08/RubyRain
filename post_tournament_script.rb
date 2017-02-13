#should run every monday morning

players = Stock.all
tournament = Tournament.find_by(index: Rails.application.config.current_tournament_index)
tournament[:tournament_info]["IsOver"] = true
puts(tournament[:tournament_info]["Name"])

for player in players
  pt = PlayerTournament.where("stock_id = ? AND tournament_id = ?", player.id, tournament.id)
  if (pt.empty?)
    puts(player[:name].to_s + " did not play in " + tournament[:tournament_info]["Name"].to_s)
  else
    puts(player[:name].to_s + " played in " + tournament[:tournament_info]["Name"].to_s)

    uri = URI('https://api.fantasydata.net/golf/v2/json/PlayerTournamentStatsByPlayer/' + tournament[:tournament_info]["TournamentID"].to_s + '/' + 
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

      info.delete("Rounds") #maybe want later but don't see the need for storing info on every single hole

      player_tournament = PlayerTournament.find_by(stock_id: player.id, tournament_id: tournament.id)
      player_tournament[:player_tournament_info] = info
      player_tournament.save

      if (info["Rank"] != 'nil') #can switch to MadeCut when data isn't scrambled
        puts(info["Rank"])

        player[:made_cut] = player[:made_cut] + 1
        if (info["Rank"].to_i < 25)
          player[:top_twenty_five] = player[:top_twenty_five] + 1
        end
        if (info["Rank"].to_i < 10)
          player[:top_ten] = player[:top_ten] + 1
        end
        if (info["Rank"].to_i == 1)
          player[:first] = player[:first] + 1
        elsif (info["Rank"].to_i == 2)
          player[:second] = player[:second] + 1
        elsif (info["Rank"].to_i == 3)
          player[:third] = player[:third] + 1
        end
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
