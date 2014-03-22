class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :name, null: false
      t.integer :course_id, null: false

      t.timestamps
    end
  end
end
