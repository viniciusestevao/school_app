class Course < ApplicationRecord
  has_many :course_nodes, dependent: :destroy
end
