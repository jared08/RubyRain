class AddPostsStocksTable < ActiveRecord::Migration[5.0]
  def change
    create_table :posts_stocks, id: false do |t|
      t.belongs_to :posts, index: true
      t.belongs_to :stocks, index: true
    end
  end
end
