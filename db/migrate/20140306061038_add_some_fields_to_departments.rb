class AddSomeFieldsToDepartments < ActiveRecord::Migration
  def change
    add_column :departments, :director_manage_seminar_scheduling, :boolean, null: false, default: true
    add_column :departments, :director_manage_sidang_scheduling, :boolean, null: false, default: false
    add_column :departments, :director_set_local_seminar, :boolean, null: false, default: false
    add_column :departments, :director_set_local_sidang, :boolean, null: false, default: false
  end
end
