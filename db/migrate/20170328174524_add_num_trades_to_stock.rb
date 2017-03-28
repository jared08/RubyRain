class AddNumTradesToStock < ActiveRecord::Migration[5.0]
  def change
    add_column :stocks, :num_trades, :integer, :default => 0
  end
end
