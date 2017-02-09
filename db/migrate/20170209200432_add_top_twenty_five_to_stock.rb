class AddTopTwentyFiveToStock < ActiveRecord::Migration[5.0]
  def change
    add_column :stocks, :top_twenty_five, :int, default: 0
  end
end
