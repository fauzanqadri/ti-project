class CreateFaculties < ActiveRecord::Migration
  def change
    create_table :faculties do |t|
      t.string :name
      t.text :description
      t.string :website
      t.integer :departments_count, default: 0
      t.integer :staffs_count, default: 0
      t.timestamps
    end
  end
end
