class AddOpenPriceToStock < ActiveRecord::Migration[5.0]
  def change
    add_column :stocks, :open_price, :float
  end
end
