class AddApprovedTimeToSupervisors < ActiveRecord::Migration
  def change
    add_column :supervisors, :approved_time, :datetime
  end
end
