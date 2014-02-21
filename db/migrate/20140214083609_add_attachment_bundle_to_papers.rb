class AddAttachmentBundleToPapers < ActiveRecord::Migration
  def self.up
    change_table :papers do |t|
      t.attachment :bundle
    end
  end

  def self.down
    drop_attached_file :papers, :bundle
  end
end
