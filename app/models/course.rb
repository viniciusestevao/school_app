class Course < ApplicationRecord
  has_many :course_nodes, dependent: :destroy

  validates :title, presence: true, length: { maximum: 160 }
end
