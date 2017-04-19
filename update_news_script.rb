require 'net/http'

golfers = Stock.where(:sport => 'Golf')

for golfer in golfers

  url = 'https://api.fantasydata.net/golf/v2/json/NewsByPlayerID/' + golfer[:PlayerID].to_s
  uri = URI(url)

  request = Net::HTTP::Get.new(uri.request_uri)
  request['Ocp-Apim-Subscription-Key'] = '34380396ef994539b30aa22ac1759ffb'
  request.body = "{body}"

  response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
    http.request(request)
  end

  #TODO Need to not allow for duplicates
  for news in JSON.parse(response.body)
    new_news = golfer.news.new(news)
    new_news.save
  end
end
