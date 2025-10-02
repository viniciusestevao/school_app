class CreatePeriods < ActiveRecord::Migration[8.0]
  def change
    create_table :periods do |t|
      t.references :course_node, null: false, foreign_key: true
      t.integer :kind, null: false, default: 0   # 0=none, 1=days, 2=weekly, 3=monthly
      t.integer :value

      t.timestamps
    end
  end
end
