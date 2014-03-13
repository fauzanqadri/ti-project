class AddAttachmentImageToAvatars < ActiveRecord::Migration
  def self.up
    change_table :avatars do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :avatars, :image
  end
end
