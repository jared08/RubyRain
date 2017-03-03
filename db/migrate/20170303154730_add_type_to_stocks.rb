class AddTypeToStocks < ActiveRecord::Migration[5.0]
  def change
    add_column :stocks, :type, :string
  end
end
