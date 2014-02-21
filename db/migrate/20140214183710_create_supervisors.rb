class CreateSupervisors < ActiveRecord::Migration
  def change
    create_table :supervisors do |t|
      t.integer :course_id, :null => false
      t.integer :lecturer_id, :null => false
      t.boolean :approved, :null => false, default: false
      t.string :userable_type, :null => false, default: ""
      t.integer :userable_id, :null => false
      t.timestamps
    end
  end
end
