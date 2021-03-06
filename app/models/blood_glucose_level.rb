class BloodGlucoseLevel < ApplicationRecord

  belongs_to :user, foreign_key: :user_id

  validates :glucose_level, :reading_time, presence: true
  validate :check_reading_date_reached_max, :check_date_is_valid

  scope :report_between_2_dates, -> (from_date, to_date) { where("DATE(reading_time) BETWEEN ? AND ?", from_date, to_date) }


  def self.filter(params, user)
    res = self.where(user: user)
    if params["report_type"] == "1"
      res.where("DATE(reading_time) = ?", params[:selected_date])
    elsif params["report_type"] == "2"
      date = Date.parse(params[:selected_date])
      res.report_between_2_dates(date.beginning_of_month, date)
    elsif params["report_type"] == "3"
      date = Date.parse(params[:selected_date])
      res.report_between_2_dates(date.beginning_of_month, date.end_of_month)
    else
      res.where("reading_time >= ?", Date.current)
    end
  end

  private

  def check_date_is_valid
    if reading_time && reading_time.to_date > Date.current
      self.errors.add(:reading_time, "Future date is not allowed.")
    end
  end

  def check_reading_date_reached_max
    return true unless reading_time
    unless BloodGlucoseLevel.where(user: self.user).where("DATE(reading_time) = ?", reading_time.strftime("%Y-%m-%d")).count < 4
      self.errors.add(:reading_time, "Only 4 entries are allowed per day.")
    end
  end
end