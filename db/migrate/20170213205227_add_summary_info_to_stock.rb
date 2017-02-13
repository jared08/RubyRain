class AddSummaryInfoToStock < ActiveRecord::Migration[5.0]
  def change
    add_column :stocks, :high, :float
    add_column :stocks, :low, :float
    add_column :stocks, :season_high, :float
    add_column :stocks, :season_low, :float
    add_column :stocks, :volume, :integer
    add_column :stocks, :earnings, :integer
  end
end
