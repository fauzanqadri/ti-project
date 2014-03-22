class AddAttachmentPackageToImports < ActiveRecord::Migration
  def self.up
    change_table :imports do |t|
      t.attachment :package
    end
  end

  def self.down
    drop_attached_file :imports, :package
  end
end
