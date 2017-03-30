class RemoveFieldsFromStock < ActiveRecord::Migration[5.0]
  def change
    remove_column :stocks, :player_id, :integer
    remove_column :stocks, :player_info, :text
  end
end
