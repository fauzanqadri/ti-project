class RemoveVersionColumnFromAssessments < ActiveRecord::Migration
  def change
  	remove_column :assessments, :version
  end
end
