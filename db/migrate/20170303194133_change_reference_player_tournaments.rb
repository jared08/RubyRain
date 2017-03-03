class ChangeReferencePlayerTournaments < ActiveRecord::Migration[5.0]
  def change
    remove_reference :player_tournaments, :stock
    remove_reference :player_tournaments, :golfer_id
    add_reference :player_tournaments, :golfer
  end
end
