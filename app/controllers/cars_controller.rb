class CarsController < ApplicationController
  def index
    @cars = Car.all
  end

  def new
    @car = Car.new
  end

  def create
    @car = Car.new(params.require(:car).permit(:plate, :brand, :model, :color, :city, :address, :photo))
    if @car.save
      redirect_to @car
    else
      render :new
    end
  end

  def show
    @car = Car.find(params[:id])
  end
end
