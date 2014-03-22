class AddPackageOriginalFileNameToImports < ActiveRecord::Migration
  def change
    add_column :imports, :package_original_file_name, :string, null: false, default: ""
  end
end
