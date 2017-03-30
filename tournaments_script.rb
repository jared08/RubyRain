require 'net/http'

uri = URI('https://api.fantasydata.net/golf/v2/json/Tournaments')

request = Net::HTTP::Get.new(uri.request_uri)

request['Ocp-Apim-Subscription-Key'] = '34380396ef994539b30aa22ac1759ffb'

request.body = "{body}"

response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
    http.request(request)
end

tournament_list = JSON.parse(response.body)

index = 0
for tournament in tournament_list
  if (tournament["StartDate"][0, 4] == "2017")
    new_tournament = Tournament.new()

    new_tournament[:TournamentID] = tournament["TournamentID"]
    new_tournament[:Name] = tournament["Name"]
    new_tournament[:StartDate] = tournament["StartDate"]
    new_tournament[:EndDate] = tournament["EndDate"]
    new_tournament[:IsOver] = tournament["IsOver"]
    new_tournament[:IsInProgress] = tournament["IsInProgress"]
    new_tournament[:Venue] = tournament["Venu"]
    new_tournament[:Location] = tournament["Location"]
    new_tournament[:Par] = tournament["Par"]
    new_tournament[:Yards] = tournament["Yards"]
    new_tournament[:Purse] = tournament["Purse"]   

    new_tournament[:index] = index
    index = index + 1

    new_tournament.save
  end
end

