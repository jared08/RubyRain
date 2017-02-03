class AddCashToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :cash, :float, default: 25000.0
  end
end
