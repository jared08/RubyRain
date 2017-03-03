tournament = Tournament.find_by(index: Rails.application.config.current_tournament_index)
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
puts response.body
