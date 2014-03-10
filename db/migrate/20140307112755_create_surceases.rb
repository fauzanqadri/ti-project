class CreateSurceases < ActiveRecord::Migration
  def change
    create_table :surceases do |t|
      t.integer :course_id, null: false
      t.string :provenable_type, null: false
      t.integer :provenable_id, null: false
      t.boolean :is_finish, null: false, default: false

      t.timestamps
    end
  end
end
