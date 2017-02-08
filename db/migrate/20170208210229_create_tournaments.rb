class CreateTournaments < ActiveRecord::Migration[5.0]
  def change
    create_table :tournaments do |t|
      t.text :tournament_info

      t.timestamps
    end
  end
end
