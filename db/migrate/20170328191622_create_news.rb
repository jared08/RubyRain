class CreateNews < ActiveRecord::Migration[5.0]
  def change
    create_table :news do |t|
      t.belongs_to :stock, index: true

      t.integer :NewsID
      t.integer :PlayerID
      t.string :Title
      t.string :Content
      t.string :Url
      t.string :Source
      t.string :TermsOfUse
      t.string :Updated
      
      t.timestamps
    end
  end
end
