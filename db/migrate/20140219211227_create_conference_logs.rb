class CreateConferenceLogs < ActiveRecord::Migration
  def change
    create_table :conference_logs do |t|
      t.integer :conference_id, null: false
      t.integer :supervisor_id, null: false
      t.boolean :approved, null: false, default: false

      t.timestamps
    end
  end
end
