stocks = Stock.all

for stock in stocks
  stock[:PlayerID] = stock[:player_info]["PlayerID"]
  stock[:PhotoUrl] = stock[:player_info]["PhotoUrl"]
  
  stock.save 

  golfer = Golfer.find_by(stock_id: stock[:id])

  golfer[:Weight] = stock[:player_info]["Weight"]
  golfer[:Swings] = stock[:player_info]["Swings"]
  golfer[:PgaDebut] = stock[:player_info]["PgaDebut"]
  golfer[:Country] = stock[:player_info]["Country"]
  golfer[:BirthDate] = stock[:player_info]["BirthDate"]
  golfer[:BirthCity] = stock[:player_info]["BirthCity"]
  golfer[:BirthState] = stock[:player_info]["BirthState"]
  golfer[:College] = stock[:player_info]["College"]

  golfer.save
end
