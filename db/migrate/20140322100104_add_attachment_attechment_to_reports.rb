class AddAttachmentAttechmentToReports < ActiveRecord::Migration
  def self.up
    change_table :reports do |t|
      t.attachment :attachment
    end
  end

  def self.down
    drop_attached_file :reports, :attachment
  end
end
