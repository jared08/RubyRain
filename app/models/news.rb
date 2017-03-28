class News < ApplicationRecord
  belongs_to :stock

  validates :NewsID, :presence => true, :uniqueness => true
end
