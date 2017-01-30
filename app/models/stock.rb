class Stock < ApplicationRecord
  has_many :holdings
  has_many :users, through: :holdings
end
