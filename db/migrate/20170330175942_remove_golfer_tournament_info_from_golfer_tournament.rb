class RemoveGolferTournamentInfoFromGolferTournament < ActiveRecord::Migration[5.0]
  def change
    remove_column :golfer_tournaments, :golfer_tournament_info, :text
  end
end
