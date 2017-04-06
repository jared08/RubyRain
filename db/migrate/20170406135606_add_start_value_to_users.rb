class AddStartValueToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :start_value, :float
  end
end
