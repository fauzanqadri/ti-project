class CreateStaffs < ActiveRecord::Migration
  def change
    create_table :staffs do |t|
      t.string :full_name
      t.text :address
      t.date :born
      t.date :staff_since
      t.integer :faculty_id

      t.timestamps
    end
    add_index :staffs, :faculty_id
  end
end
