class AddIsFinishToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :is_finish, :boolean, default:false
  end
end
