stocks = Stock.all

for stock in stocks
  stock[:high] = stock[:current_price]
  stock[:low] = stock[:current_price]

  stock.save
end

