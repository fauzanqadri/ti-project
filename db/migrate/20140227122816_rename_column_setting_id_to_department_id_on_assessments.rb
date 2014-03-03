class RenameColumnSettingIdToDepartmentIdOnAssessments < ActiveRecord::Migration
  def change
  	rename_column :assessments, :setting_id, :department_id
  end
end
