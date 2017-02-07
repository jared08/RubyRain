class AddPlayerInfoToStock < ActiveRecord::Migration[5.0]
  def change
    add_column :stocks, :player_info, :text
  end
end
