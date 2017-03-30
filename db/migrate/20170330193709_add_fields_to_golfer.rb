class AddFieldsToGolfer < ActiveRecord::Migration[5.0]
  def change
    add_column :golfers, :Weight, :integer
    add_column :golfers, :Swings, :string
    add_column :golfers, :PgaDebut, :integer
    add_column :golfers, :Country, :string
    add_column :golfers, :BirthDate, :date
    add_column :golfers, :BirthCity, :string
    add_column :golfers, :BirthState, :string
    add_column :golfers, :College, :string
  end
end
