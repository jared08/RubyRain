class ChangeDefaultForCash < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :cash, :float, :default => 20000.0
  end
end
