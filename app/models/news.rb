class News < ApplicationRecord
  belongs_to :stock

  validates :NewsID, :presence => true, :uniqueness => true

  self.per_page = 4
end
