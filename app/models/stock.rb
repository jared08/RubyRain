class Stock < ApplicationRecord
  has_many :holdings, :dependent => :delete_all
  has_many :users, through: :holdings

  store :player_info, accessors: [ ], coder: JSON
  serialize :player_news

  has_many :playertournaments
  has_many :tournaments, through: :playertournaments
end
