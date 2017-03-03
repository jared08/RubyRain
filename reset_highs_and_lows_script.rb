stocks = Stock.all

time = Time.now

for stock in stocks
  price = stock[:current_price]
  stock[:high] = price
  stock[:low] = price
  stock[:open_price] = price

  stock[:daily_prices].push({time: time, price: price})

  stock.save
end

