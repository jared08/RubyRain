class Stock < ApplicationRecord
  has_many :holdings, :dependent => :delete_all
  has_many :users, through: :holdings
end
