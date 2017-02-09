class AddFirstToStock < ActiveRecord::Migration[5.0]
  def change
    add_column :stocks, :first, :int, default: 0
  end
end
