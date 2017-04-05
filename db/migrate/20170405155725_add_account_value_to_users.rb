class AddAccountValueToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :account_value, :float, default: 20000
  end
end
