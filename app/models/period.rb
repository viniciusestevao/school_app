class Period < ApplicationRecord
  belongs_to :course_node

  enum :kind, { weekly: 0, monthly: 1, days: 2 }

  validates :lessons_per_period, numericality: { greater_than: 0 }
  validates :interval_days, presence: true, numericality: { greater_than: 0 }, if: :days?
  validates :interval_days, absence: true, unless: :days?
end
