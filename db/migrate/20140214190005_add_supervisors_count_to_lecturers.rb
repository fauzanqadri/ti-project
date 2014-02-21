class AddSupervisorsCountToLecturers < ActiveRecord::Migration
  def change
    add_column :lecturers, :supervisors_count, :integer, null: false, default: 0
  end
end
