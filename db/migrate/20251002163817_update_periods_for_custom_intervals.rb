class UpdatePeriodsForCustomIntervals < ActiveRecord::Migration[8.0]
  def change
    rename_column :periods, :value, :interval_days

    add_column :periods, :lessons_per_period, :integer, null: false, default: 1
  end
end
