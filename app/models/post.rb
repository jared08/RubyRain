class Post < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :stocks

  serialize :custom_tags
end
