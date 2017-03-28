class RemovePlayerNewsFromStock < ActiveRecord::Migration[5.0]
  def change
    remove_column :stocks, :player_news, :text
  end
end
