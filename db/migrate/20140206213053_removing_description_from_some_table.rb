class RemovingDescriptionFromSomeTable < ActiveRecord::Migration
  def change
  	remove_column :faculties, :description
  	remove_column :departments, :description
  	remove_column :concentrations, :description
  end
end
