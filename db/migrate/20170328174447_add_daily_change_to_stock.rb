class AddDailyChangeToStock < ActiveRecord::Migration[5.0]
  def change
    add_column :stocks, :daily_change, :float, :default => 0.0
  end
end
