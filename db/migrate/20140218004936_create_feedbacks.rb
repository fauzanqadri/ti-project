class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.text :content, null: false
      t.integer :course_id, null: false
      t.integer :userable_id, null: false
      t.string :userable_type, null: false
      t.timestamps
    end
  end
end
