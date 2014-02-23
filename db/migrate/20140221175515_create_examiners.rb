class CreateExaminers < ActiveRecord::Migration
  def change
    create_table :examiners do |t|
      t.integer :sidang_id, null: false
      t.integer :lecturer_id, null: false

      t.timestamps
    end
  end
end
