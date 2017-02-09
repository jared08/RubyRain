class AddIndexToTournaments < ActiveRecord::Migration[5.0]
  def change
    add_column :tournaments, :index, :int
  end
end
