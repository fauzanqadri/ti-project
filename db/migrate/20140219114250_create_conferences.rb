class CreateConferences < ActiveRecord::Migration
  def change
    create_table :conferences do |t|
      t.string :local
      t.datetime :start
      t.datetime :end
      t.integer :skripsi_id, null: false
      t.string :type, null: false
      t.integer :userable_id, null: false
      t.string :userable_type, null: false
      t.boolean :supervisor_approval, null: false, default: false
      t.timestamps
    end
  end
end
