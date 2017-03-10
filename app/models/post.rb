class Post < ApplicationRecord
  belongs_to :user
  serialize :tags
end
