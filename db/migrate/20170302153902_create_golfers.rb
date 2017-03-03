class CreateGolfers < ActiveRecord::Migration[5.0]
  def change
    create_table :golfers do |t|
      t.integer :first
      t.integer :second
      t.integer :third
      t.integer :top_ten
      t.integer :top_twenty_five
      t.integer :made_cut

      t.timestamps
    end
  end
end
