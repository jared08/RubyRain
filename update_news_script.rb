stocks = Stock.all
debugger
for stock in stocks
    require 'net/http'

    url = 'https://api.fantasydata.net/golf/v2/json/NewsByPlayerID/' + stock[:player_id].to_s
    uri = URI(url)

    request = Net::HTTP::Get.new(uri.request_uri)
    request['Ocp-Apim-Subscription-Key'] = '34380396ef994539b30aa22ac1759ffb'
    request.body = "{body}"

    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(request)
    end

    for news in JSON.parse(response.body)
      new_news = stock.news.new(news)
      new_news.save
    end
end
