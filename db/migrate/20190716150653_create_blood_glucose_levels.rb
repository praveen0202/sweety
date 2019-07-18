class CreateBloodGlucoseLevels < ActiveRecord::Migration[5.2]
  def change
    create_table :blood_glucose_levels do |t|
      t.datetime :reading_time, nil: false
      t.integer :glucose_level, nil: false

      t.timestamps
    end
  end
end
