class Stock < ApplicationRecord
  has_many :holdings, :dependent => :delete_all
  has_many :users, through: :holdings

  store :player_info, accessors: [ ], coder: JSON
  serialize :player_news

  serialize :daily_prices

end
