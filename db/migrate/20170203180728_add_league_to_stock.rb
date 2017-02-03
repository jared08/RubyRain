class AddLeagueToStock < ActiveRecord::Migration[5.0]
  def change
    add_column :stocks, :league, :string
  end
end
