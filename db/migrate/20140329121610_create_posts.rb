class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title, null: false, default: ""
      t.text :content
      t.boolean :publish, null: false, default: false
      t.string :boundable_type, null: false, default: "Global"
      t.integer :boundable_id, null: false
      t.timestamps
    end
  end
end
