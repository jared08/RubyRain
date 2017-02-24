class AddDailyPricesToStock < ActiveRecord::Migration[5.0]
  def change
    add_column :stocks, :daily_prices, :text
  end
end
