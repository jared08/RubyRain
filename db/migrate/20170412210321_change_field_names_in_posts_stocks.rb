class ChangeFieldNamesInPostsStocks < ActiveRecord::Migration[5.0]
  def change
    rename_column :posts_stocks, :posts_id, :post_id
    rename_column :posts_stocks, :stocks_id, :stock_id
  end
end
