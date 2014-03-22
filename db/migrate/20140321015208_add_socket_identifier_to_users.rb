class AddSocketIdentifierToUsers < ActiveRecord::Migration
  def change
    add_column :users, :socket_identifier, :string, null: false, default: "", unique: true
  end
end
