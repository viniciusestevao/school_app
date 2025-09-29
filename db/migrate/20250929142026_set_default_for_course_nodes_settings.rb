class SetDefaultForCourseNodesSettings < ActiveRecord::Migration[8.0]
  def change
    change_column_default :course_nodes, :settings, from: nil, to: {}
    change_column_null :course_nodes, :settings, false
  end
end
