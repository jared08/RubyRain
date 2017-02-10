require 'net/http'

player_id = '40000991'
player = Stock.find_by(player_id: player_id)

player[:first] = 0
player[:second] = 0
player[:third] = 0
player[:top_ten] = 0
player[:top_twenty_five] = 0
player[:made_cut] = 0
player.save

params = Hash.new

tournaments = Tournament.all
for tournament in tournaments
  if (tournament[:tournament_info]["IsOver"]) 
    id = tournament[:tournament_info]["TournamentID"].to_s
    puts(tournament[:tournament_info]["Name"])
 
    uri = URI('https://api.fantasydata.net/golf/v2/json/PlayerTournamentStatsByPlayer/' + id + '/' + player_id)

    request = Net::HTTP::Get.new(uri.request_uri)
    request['Ocp-Apim-Subscription-Key'] = '34380396ef994539b30aa22ac1759ffb'
    request.body = "{body}"

    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(request)
    end

    if (response.body != '') #returns blank if the player didn't play in the tournament
      info = JSON.parse(response.body)
 
      info.delete("Rounds") #maybe want later but don't see the need for storing info on every single hole

      params[:tournament] = tournament
      params[:player_tournament_info] = info 
      
      player_tournament = PlayerTournament.new
      player_tournament = player.player_tournaments.create(params)
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

