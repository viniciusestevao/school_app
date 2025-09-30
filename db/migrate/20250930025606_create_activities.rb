class CreateActivities < ActiveRecord::Migration[8.0]
  def change
    create_table :activities do |t|
      t.references :course_node, null: false, foreign_key: true, index: { unique: true }
      t.string :title
      t.integer :points
      t.datetime :due_at
      t.integer :submission_type

      t.timestamps
    end
  end
end
