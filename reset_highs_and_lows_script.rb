stocks = Stock.all

time = Time.now

for stock in stocks
  price = stock[:current_price]
  stock[:high] = price
  stock[:low] = price
  stock[:open_price] = price

  stock[:daily_change] = 0.0
  stock[:num_trades] = 0

  stock[:daily_prices].push({time: time, price: price})

  stock.save
end

users = User.all

for user in users
  user[:start_value] = user[:account_value]
  user.save
end
