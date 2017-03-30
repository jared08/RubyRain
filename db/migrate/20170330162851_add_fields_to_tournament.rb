class AddFieldsToTournament < ActiveRecord::Migration[5.0]
  def change
    add_column :tournaments, :TournamentID, :integer
    add_column :tournaments, :Name, :string
    add_column :tournaments, :StartDate, :date
    add_column :tournaments, :EndDate, :date
    add_column :tournaments, :IsOver, :boolean
    add_column :tournaments, :IsInProgress, :boolean
    add_column :tournaments, :Venue, :string
    add_column :tournaments, :Location, :string
    add_column :tournaments, :Par, :integer
    add_column :tournaments, :Yards, :integer
    add_column :tournaments, :Purse, :decimal
  end
end
