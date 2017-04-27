stocks = Stock.all

for stock in stocks
  dp = stock.daily_prices
  dp.shift
  stock.save
end
