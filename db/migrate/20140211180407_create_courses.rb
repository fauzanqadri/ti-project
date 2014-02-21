class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :title, :null => false, :default => ""
      t.text :description
      t.integer :concentration_id
      t.integer :student_id, :null => false
      t.string :type, :null => false, :default => ""
      t.integer :supervisors_count, :null => false, :default => 0

      t.timestamps
    end
  end
end
