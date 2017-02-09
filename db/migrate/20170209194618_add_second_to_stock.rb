class AddSecondToStock < ActiveRecord::Migration[5.0]
  def change
    add_column :stocks, :second, :int, default: 0
  end
end
