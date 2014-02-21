class CreateLecturers < ActiveRecord::Migration
  def change
    create_table :lecturers do |t|
      t.string :nip
      t.string :nid
      t.string :full_name, :null => false, :default => ""
      t.text :address
      t.date :born
      t.string :level, :null => false, :default => "Lektor"
      t.string :front_title
      t.string :back_title
      t.boolean :is_admin, default: false
      t.integer :department_id
      t.timestamps
    end
    add_index :lecturers, :nip
    add_index :lecturers, :nid
    add_index :lecturers, :department_id
  end
end
