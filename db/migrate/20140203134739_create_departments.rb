class CreateDepartments < ActiveRecord::Migration
   def change
    create_table :departments do |t|
      t.string :name
      t.text :description
      t.text :website
      t.integer :faculty_id, null: false
      t.integer :students_count, default: 0
      t.integer :lecturers_count, default: 0
      t.timestamps
    end
    add_index :departments, :faculty_id
  end
end
