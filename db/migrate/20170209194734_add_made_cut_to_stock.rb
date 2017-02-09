class AddMadeCutToStock < ActiveRecord::Migration[5.0]
  def change
    add_column :stocks, :made_cut, :int, default: 0
  end
end
