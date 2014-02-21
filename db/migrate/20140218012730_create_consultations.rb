class CreateConsultations < ActiveRecord::Migration
  def change
    create_table :consultations do |t|
      t.text :content, null: false
      t.datetime :next_consult
      t.integer :course_id, null: false
      t.integer :consultable_id, null: false
      t.string :consultable_type, null: false
      t.timestamps
    end
  end
end
