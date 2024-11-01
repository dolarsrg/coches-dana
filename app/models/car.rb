class Car < ApplicationRecord
  has_one_attached :photo
  validates :plate, presence: true, uniqueness: true
end
