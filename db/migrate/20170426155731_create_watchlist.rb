class CreateWatchlist < ActiveRecord::Migration[5.0]
  def change
    create_table :watchlists do |t|
      t.references :user, foreign_key: true
      t.references :stock, foreign_key: true
    end
  end
end

