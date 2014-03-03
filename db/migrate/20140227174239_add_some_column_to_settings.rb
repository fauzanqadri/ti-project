class AddSomeColumnToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :department_director, :integer
    add_column :settings, :department_secretary, :integer
  end
end
