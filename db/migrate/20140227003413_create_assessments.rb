class CreateAssessments < ActiveRecord::Migration
  def change
    create_table :assessments do |t|
      t.text :aspect, null: false
      t.integer :percentage, null: false
      t.string :category, null: false
      t.integer :version, null: false, default: 1
      t.integer :setting_id, null: false
      t.timestamps
    end
  end
end
