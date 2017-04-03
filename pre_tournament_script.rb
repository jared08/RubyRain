#should run every friday (6 days before tournament)


tournament = Tournament.find_by(index: Rails.application.config.current_tournament_index)
tournament[:IsInProgress] = true
tournament.save
puts(tournament[:Name])

require 'net/http'

uri = URI('https://api.fantasydata.net/golf/v2/json/PlayerTournamentProjectionStats/' + tournament[:TournamentID].to_s)

request = Net::HTTP::Get.new(uri.request_uri)
# Request headers
request['Ocp-Apim-Subscription-Key'] = '34380396ef994539b30aa22ac1759ffb'
# Request body
request.body = "{body}"

response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
  http.request(request)
end

tournament_info = JSON.parse(response.body)

players = Stock.where(sport: "Golf")


for player in players
  found = false
  for golfer_info in tournament_info
    if player[:PlayerID] == golfer_info["PlayerID"]
      puts(player[:name].to_s + " is playing!")

      golfer = Golfer.find_by(stock_id: player[:id])

      golfer_tournament = golfer.golfer_tournaments.create

      golfer_tournament[:tournament_id] = tournament[:id]
      golfer_tournament[:Rank] = golfer_info["Rank"]
      golfer_tournament.save

      found = true 
      break
    end
  end
  if !found
    puts(player[:name].to_s + " is not playing..")
  end
end

