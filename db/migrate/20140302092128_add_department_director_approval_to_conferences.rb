class AddDepartmentDirectorApprovalToConferences < ActiveRecord::Migration
  def change
    add_column :conferences, :department_director_approval, :boolean, default: false
  end
end
