# == Schema Information
#
# Table name: reports
#
#  id                      :integer          not null, primary key
#  name                    :string(255)      not null
#  course_id               :integer          not null
#  created_at              :datetime
#  updated_at              :datetime
#  attechment_file_name    :string(255)
#  attechment_content_type :string(255)
#  attechment_file_size    :integer
#  attechment_updated_at   :datetime
#

class Report < ActiveRecord::Base
	has_paper_trail
	has_attached_file :attachment,
										path: ENV["PAPERCLIP_PATH"] + "/:class/attachment/:course_type/:course_id/:filename",
										preserve_files: true
	belongs_to :course, counter_cache: true

	validates_attachment_presence :attachment
	validates :name, presence: true
	validates :course_id, presence: true

	before_post_process :renaming_attachment_file

	Paperclip.interpolates :course_id do |attachment, style|
		attachment.instance.course_id
	end

	Paperclip.interpolates :course_type do |attachment, style|
		attachment.instance.course.type
	end

	private
	def renaming_attachment_file
		ext = File.extname(attachment_file_name).downcase
    self.attachment.instance_write :file_name, "#{Time.now.to_i.to_s}#{ext}"
	end

end

