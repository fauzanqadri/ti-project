class CreatePklAssessments < ActiveRecord::Migration
  def change
    create_table :pkl_assessments do |t|
      t.text :aspect, null: false, default: ""
      t.string :category, null: false, default: ""
      t.integer :percentage
      t.integer :department_id, null: false

      t.timestamps
    end
  end
end
