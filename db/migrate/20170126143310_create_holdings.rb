class CreateHoldings < ActiveRecord::Migration[5.0]
  def change
    create_table :holdings do |t|
      t.references :user, foreign_key: true
      t.references :stock, foreign_key: true
      t.string :type_of_holding
      t.float :quantity
      t.float :price_at_purchase

      t.timestamps
    end
  end
end
