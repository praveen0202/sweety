class AddColumnToGlucoseLevels < ActiveRecord::Migration[5.2]
  def change
    add_column :blood_glucose_levels, :user_id, :integer
  end
end
