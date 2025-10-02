class Classroom < ApplicationRecord
  belongs_to :course
  belongs_to :teacher, class_name: "User"

  has_many :classroom_enrollments, dependent: :destroy
  has_many :students, through: :classroom_enrollments, source: :user

  validates :title, presence: true
end
