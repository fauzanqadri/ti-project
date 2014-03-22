class ChangeStudentsAttributes < ActiveRecord::Migration
  def change
  	remove_column :students, :student_since
  	add_column :students, :student_since, :integer
  	# change_column :students, :student_since, :integer
  	add_column :students, :sex, :string, limit: 2
  	add_column :students, :home_number, :string
  	add_column :students, :phone_number, :string
  end
end
