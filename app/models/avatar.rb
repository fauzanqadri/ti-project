class Avatar < ActiveRecord::Base
	STYLES = { large: "200x200#", medium: "150x150#", small: "64x64#", thumb: "10x10#"}
	has_attached_file :image, 
										styles: STYLES, 
										default_url: "http://placehold.it/150x150",
										url: "/avatar/:id/:style",
										path: "/Users/fauzanqadri/paperclip_development/:class/image/:userable_type/:userable_id/:style/:filename"
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
