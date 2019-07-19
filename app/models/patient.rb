class Patient < User

  has_many :blood_glucose_levels, foreign_key: :user_id, dependent: :destroy

end