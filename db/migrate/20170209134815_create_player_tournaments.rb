class CreatePlayerTournaments < ActiveRecord::Migration[5.0]
  def change
    create_table :player_tournaments do |t|
      t.belongs_to :stock, index: true
      t.belongs_to :tournament, index: true
      t.text :player_tournament_info

      t.timestamps
    end
  end
end
