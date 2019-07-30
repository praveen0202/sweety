class BloodGlucoseLevelsController < ApplicationController

  def index
    @blood_glucose_levels = BloodGlucoseLevel.filter(params, current_user)
    reading_minmax
  end

  def new
    @blood_glucose_level = BloodGlucoseLevel.new(reading_time: Time.current)
  end

  def create
    @blood_glucose_level = BloodGlucoseLevel.new(blood_glucose_level_params)
    @blood_glucose_level.user = current_user
    if @blood_glucose_level.save
      @blood_glucose_levels = current_user.blood_glucose_levels.where("reading_time >= ?", Date.current)
      reading_minmax
    end
  end

  def reading_minmax
    return if @blood_glucose_levels.empty?
    glucose_levels = @blood_glucose_levels.map(&:glucose_level)
    @min_reading, @max_reading = glucose_levels.minmax
    @average_reading = glucose_levels.sum/glucose_levels.count
  end

  private

  def blood_glucose_level_params
    params.require(:blood_glucose_level).permit(:reading_time, :glucose_level)
  end

end