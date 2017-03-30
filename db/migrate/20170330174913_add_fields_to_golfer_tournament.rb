class AddFieldsToGolferTournament < ActiveRecord::Migration[5.0]
  def change
    add_column :golfer_tournaments, :Earnings, :decimal
  end
end
