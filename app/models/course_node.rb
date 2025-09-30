class CourseNode < ApplicationRecord
  belongs_to :course

  has_ancestry orphan_strategy: :adopt
  acts_as_list scope: [:course_id, :ancestry]

  enum :kind, { container: 0, activity: 1, resource: 2 }, prefix: true

  has_one :activity, dependent: :destroy
  accepts_nested_attributes_for :activity, allow_destroy: true

  validates :title, presence: true
  validate :parent_same_course

  # Valida que activity existe quando kind == activity
  # validate :activity_presence_for_activity_kind
  #
  # def activity_presence_for_activity_kind
  #   if kind == "activity" && activity.blank?
  #     errors.add(:base, "Atividade é obrigatória para nós do tipo Activity")
  #   end
  # end

  def leaf? = children.empty?
  def activity_leaf? = kind_activity? && leaf?

  private

  def parent_same_course
    return if parent.nil?
    errors.add(:parent, "deve pertencer ao mesmo curso") if parent.course_id != course_id
  end
end
