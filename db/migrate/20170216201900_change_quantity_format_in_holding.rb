class ChangeQuantityFormatInHolding < ActiveRecord::Migration[5.0]
  def change
    change_column :holdings, :quantity, :integer
  end
end
