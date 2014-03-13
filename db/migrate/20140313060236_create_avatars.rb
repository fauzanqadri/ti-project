class CreateAvatars < ActiveRecord::Migration
  def change
    create_table :avatars do |t|
    	t.string :userable_type, null: false
    	t.integer :userable_id, null: false
      t.timestamps
    end
  end
end
