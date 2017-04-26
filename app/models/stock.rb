class Stock < ApplicationRecord
  has_many :holdings, :dependent => :delete_all
  has_many :users, through: :holdings

  has_many :news
  has_and_belongs_to_many :posts

  serialize :daily_prices

  has_many :watchlists, :dependent => :delete_all
  has_many :users, through: :watchlists
end
