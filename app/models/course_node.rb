class CourseNode < ApplicationRecord
  belongs_to :course

  has_ancestry orphan_strategy: :adopt
  acts_as_list scope: [:course_id, :ancestry]

  # sem conflito com ActiveRecord#group e com prefixo "kind_"
  enum :kind, { container: 0, activity: 1, resource: 2 }, prefix: true

  validates :title, presence: true
  validate :parent_same_course

  def leaf? = children.empty?
  def activity_leaf? = kind_activity? && leaf?

  private

  def parent_same_course
    return if parent.nil?
    errors.add(:parent, "deve pertencer ao mesmo curso") if parent.course_id != course_id
  end
end
