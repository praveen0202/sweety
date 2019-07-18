class BloodGlucoseLevel < ApplicationRecord

  validates :glucose_level, :reading_time, presence: true
  validate :check_reading_date_reached_max

  def self.filter(params)
    if params["report_type"] == "1"
      self.where("DATE(reading_time) = ?", params[:selected_date])
    elsif params["report_type"] == "2"
      date = Date.parse(params[:selected_date])
      self.where("DATE(reading_time) BETWEEN ? AND ?",
                              date.beginning_of_month, date)
    elsif params["report_type"] == "3"
      date = Date.parse(params[:selected_date])
      self.where("DATE(reading_time) BETWEEN ? AND ?",
                              date.beginning_of_month, date.end_of_month)
    else
      self.where("reading_time >= ?", Date.current)
    end
  end

  def check_reading_date_reached_max
    unless BloodGlucoseLevel.where("DATE(reading_time) = ?", reading_time.strftime("%Y-%m-%d")).count < 4
      self.errors.add(:reading_time, "Only 4 entries are allowed per day.")
    end
  end
end