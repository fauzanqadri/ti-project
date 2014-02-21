class CreatePapers < ActiveRecord::Migration
  def change
    create_table :papers do |t|
      t.string :name, :null => false, :default => ""
      t.integer :course_id, :null => false
      t.timestamps
    end
  end
end
