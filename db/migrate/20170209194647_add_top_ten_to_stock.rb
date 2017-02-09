class AddTopTenToStock < ActiveRecord::Migration[5.0]
  def change
    add_column :stocks, :top_ten, :int, default: 0
  end
end
