class AddSomeColumnToImports < ActiveRecord::Migration
  def change
    add_column :imports, :total_row, :integer, default: 0, null: false
    add_column :imports, :status, :string, default: "on progress", null: false
    add_column :imports, :department_id, :integer
    # add_column :imports, :faculty_id, :integer
    add_column :imports, :userable_id, :integer, null: false
    add_column :imports, :userable_type, :string, null: false
  end
end
