class CreateCourseNodes < ActiveRecord::Migration[7.1]
  def change
    create_table :course_nodes do |t|
      t.references :course, null: false, foreign_key: true
      t.string  :title, null: false
      t.text    :description
      t.integer :kind, null: false, default: 0   # 0=group, 1=activity, 2=resource
      t.integer :position, null: false, default: 0
      t.string  :ancestry
      t.jsonb   :settings, null: false, default: {}

      t.timestamps
    end

    add_index :course_nodes, :ancestry
    add_index :course_nodes, [:course_id, :ancestry, :position], name: "index_course_nodes_on_course_ancestry_position"
  end
end
