class AddFieldsToStock < ActiveRecord::Migration[5.0]
  def change
    add_column :stocks, :PlayerID, :integer
    add_column :stocks, :PhotoUrl, :string
  end
end
