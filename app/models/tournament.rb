class Tournament < ApplicationRecord
  has_many :playertournaments
  has_many :stocks, through: :playertournaments

  store :tournament_info, accessors: [ ], coder: JSON
end
