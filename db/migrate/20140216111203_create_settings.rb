class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.integer :supervisor_skripsi_amount, null: false, default: 2
      t.integer :supervisor_pkl_amount, null: false, default: 1
      t.integer :examiner_amount, null: false, default: 2
      t.integer :maximum_lecturer_lektor_skripsi_lead, null: false, default: 10
      t.integer :maximum_lecturer_aa_skripsi_lead, null: false, default: 10
      t.integer :allow_remove_supervisor_duration, null: false, default: 3
      t.string :lecturer_lead_skripsi_rule, null: false, default: "lektor_first_then_aa"
      t.string :lecturer_lead_pkl_rule, null: false, default: "free"
      t.boolean :allow_student_create_pkl, null: false, default: true
      t.integer :department_id, null: false

      t.timestamps
    end
  end
end
