class Tournament < ApplicationRecord
  store :tournament_info, accessors: [ ], coder: JSON
end
