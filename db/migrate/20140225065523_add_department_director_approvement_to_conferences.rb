class AddDepartmentDirectorApprovementToConferences < ActiveRecord::Migration
  def change
    add_column :conferences, :department_director, :boolean, default: false
  end
end
