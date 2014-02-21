class AddFeedbacksCountToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :feedbacks_count, :integer, null: false, default: 0
  end
end
