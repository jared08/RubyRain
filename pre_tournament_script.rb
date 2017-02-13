#should run every friday (6 days before tournament)

tournament = Tournament.find_by(index: 36)
puts(tournament[:tournament_info]["Name"])

require 'net/http'

uri = URI('https://api.fantasydata.net/golf/v2/json/PlayerTournamentProjectionStats/' + tournament[:tournament_info]["TournamentID"].to_s)

request = Net::HTTP::Get.new(uri.request_uri)
# Request headers
request['Ocp-Apim-Subscription-Key'] = '34380396ef994539b30aa22ac1759ffb'
# Request body
request.body = "{body}"

response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
  http.request(request)
end

info = JSON.parse(response.body)

players = Stock.all
params = Hash.new

for player in players
  if (info.any? {|h| h["PlayerID"] == player[:player_info]["PlayerID"]})
    puts(player[:name].to_s + " played!")

    params[:tournament] = tournament

    player_tournament = PlayerTournament.new
    player_tournament = player.player_tournaments.create(params)
    player_tournament.save

  else
    puts(player[:name].to_s + " did not play..")
  end
end

