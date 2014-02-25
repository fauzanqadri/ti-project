class AddUndertakePlanToConferences < ActiveRecord::Migration
  def change
    add_column :conferences, :undertake_plan, :date
  end
end
