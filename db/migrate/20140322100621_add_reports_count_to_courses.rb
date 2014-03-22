class AddReportsCountToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :reports_count, :integer
  end
end
