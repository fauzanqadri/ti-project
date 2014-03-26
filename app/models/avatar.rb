# == Schema Information
#
# Table name: avatars
#
#  id                 :integer          not null, primary key
#  userable_type      :string(255)      not null
#  userable_id        :integer          not null
#  created_at         :datetime
#  updated_at         :datetime
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#

class Avatar < ActiveRecord::Base
	STYLES = { large: "200x200#", medium: "150x150#", small: "64x64#", thumb: "10x10#"}
	has_paper_trail
	has_attached_file :image, 
										styles: STYLES, 
										default_url: "http://placehold.it/150x150",
										url: "/avatar/:id/:style",
										path: "#{ENV["PAPERCLIP_PATH"]}/:class/image/:userable_type/:userable_id/:style/:filename",
										preserve_files: true
	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
	before_post_process :renaming_avatar_file
	belongs_to :userable, polymorphic: true

	Paperclip.interpolates :userable_id do |image, style|
		image.instance.userable_id
	end

	Paperclip.interpolates :userable_type do |image, style|
		image.instance.userable_type
	end

	Paperclip.interpolates :size do |image, style|
		stle = style == :original ? :large : style
		image.instance.class.const_get("STYLES")[stle]
	end


	private
	def renaming_avatar_file
		ext = File.extname(image_file_name).downcase
		self.image.instance_write :file_name, "#{Time.now.to_i.to_s}#{ext}"
	end
end
