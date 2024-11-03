class CarsController < ApplicationController
  def index
    if params[:search].present?
      @cars = Car.where("plate LIKE ?", "%#{params[:search]}%").order(:plate)
    else
      @cars = Car.order(:plate).all
    end
  end

  def new
    @car = Car.new
  end

  def create
    @car = Car.new(params.require(:car).permit(:plate, :brand, :model, :color, :city, :address, :photo))
    if @car.save
      redirect_to @car
    elsif colision = Car.find_by(plate: @car.plate)
      redirect_to colision
    else
      render :new
    end
  end

  def show
    @car = Car.find(params[:id])
    if @car.photo.attached?
      Tempfile.open(['photo', '.jpg']) do |file|
        file.binmode
        file.write(@car.photo.download)
        file.rewind
        exif = MiniExiftool.new(file.path)
        @latitude_dms = exif.GPSLatitude
        latitude_ref = exif.GPSLatitudeRef
        @longitude_dms = exif.GPSLongitude
        longitude_ref = exif.GPSLongitudeRef

        @latitude = dms_to_decimal(@latitude_dms, latitude_ref)
        @longitude = dms_to_decimal(@longitude_dms, longitude_ref)  
      end
    end
  end

  def update
    @car = Car.find(params[:id])
    if @car.update(params.require(:car).permit(:photo))
      redirect_to @car
    else
      render :show
    end
  end

  private

  def dms_to_decimal(dms, direction)
    parts = dms.scan(/(\d+)\D+(\d+)\D+([\d.]+)/).flatten
    degrees = parts[0].to_f
    minutes = parts[1].to_f
    seconds = parts[2].to_f
  
    decimal = degrees + (minutes / 60) + (seconds / 3600)
    decimal *= -1 if %w[S W South West].include?(direction)
    decimal
  end
end
