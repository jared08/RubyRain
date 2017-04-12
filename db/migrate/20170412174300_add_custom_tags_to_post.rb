class AddCustomTagsToPost < ActiveRecord::Migration[5.0]
  def change
    remove_column :posts, :tags, :string
    add_column :posts, :custom_tags, :string

    add_reference :posts, :stocks
  end
end
