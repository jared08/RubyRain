class ChangePostsReferences < ActiveRecord::Migration[5.0]
  def change
    remove_reference :posts, :stocks
 
    create_table :stocks_posts, id: false do |t|
      t.belongs_to :stocks, index: true
      t.belongs_to :posts, index: true
    end
  end
end
