class RemoveTypeFromStock < ActiveRecord::Migration[5.0]
  def change
    remove_column :stocks, :type, :string
  end
end
