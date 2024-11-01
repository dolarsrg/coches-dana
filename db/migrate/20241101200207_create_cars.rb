class CreateCars < ActiveRecord::Migration[7.2]
  def change
    create_table :cars do |t|
      t.string :plate
      t.string :brand
      t.string :model
      t.string :color
      t.string :city
      t.string :address
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
