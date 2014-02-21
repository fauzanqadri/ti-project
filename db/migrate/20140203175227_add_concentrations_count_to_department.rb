class AddConcentrationsCountToDepartment < ActiveRecord::Migration
  def change
    add_column :departments, :concentrations_count, :integer, default: 0
  end
end
