class ChangeGolferTournamentInfoGolferTournaments < ActiveRecord::Migration[5.0]
  def change
    change_column :golfer_tournaments, :golfer_tournament_info, :text
  end
end
