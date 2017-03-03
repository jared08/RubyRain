class AddStockToGolfer < ActiveRecord::Migration[5.0]
  def change
    add_reference :golfers, :stock, foreign_key: true
  end
end
