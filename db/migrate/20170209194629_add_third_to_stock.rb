class AddThirdToStock < ActiveRecord::Migration[5.0]
  def change
    add_column :stocks, :third, :int, default: 0
  end
end
