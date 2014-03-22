class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.string :klass_action

      t.timestamps
    end
  end
end
