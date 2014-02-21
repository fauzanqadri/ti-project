class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :nim, :null => false, :default => ""
      t.string :full_name, :null => false, :default => ""
      t.text :address
      t.date :born
      t.date :student_since
      t.integer :department_id, :null => false, :default => ""
      t.integer :pkls_count, default: 0
      t.integer :skripsis_count, default: 0
      t.timestamps
    end
    add_index :students, :nim, :unique => true
    add_index :students, :department_id
  end
end
