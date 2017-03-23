class AddPriceToChangeToStock < ActiveRecord::Migration[5.0]
  def change
    add_column :stocks, :price_to_change, :float
  end
end
