class RemoveTournamentInfoFromTournament < ActiveRecord::Migration[5.0]
  def change
    remove_column :tournaments, :tournament_info, :text
  end
end
