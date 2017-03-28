class ChangeUpdatedNews < ActiveRecord::Migration[5.0]
  def change
    change_column :news, :Updated, :date
  end
end
