class Car < ApplicationRecord
  has_one_attached :photo
  validates :plate, presence: true, uniqueness: true

  before_validation :upcase_plate

  def upcase_plate
    # Elimina espacios y convierte a mayúsculas
    self.plate = plate.strip.upcase
  end
end
