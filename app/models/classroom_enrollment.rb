class ClassroomEnrollment < ApplicationRecord
  belongs_to :classroom
  belongs_to :user

  validate :user_is_student

  private

  def user_is_student
    if user.admin?
      errors.add(:user, "não pode ser professor")
    end
  end
end