stocks = Stock.all


for stock in stocks
  price = stock[:current_price]
  stock[:high] = price
  stock[:low] = price
  stock[:open_price] = price

  stock[:daily_prices].push({time: Time.now, price: price})

  stock.save
end

