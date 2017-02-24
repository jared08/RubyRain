stocks = Stock.all


for stock in stocks
  price = stock[:current_price]
  stock[:high] = price
  stock[:low] = price
  stock[:open_price] = price
  stock[:daily_prices].push(price)

  stock.save
end

