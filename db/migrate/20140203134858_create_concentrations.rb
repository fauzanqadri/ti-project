class CreateConcentrations < ActiveRecord::Migration
  def change
    create_table :concentrations do |t|
      t.string :name
      t.text :description
      t.integer :department_id
      t.timestamps
    end
    add_index :concentrations, :department_id
  end
end
