# == Schema Information
#
# Table name: papers
#
#  id                  :integer          not null, primary key
#  name                :string(255)      default(""), not null
#  course_id           :integer          not null
#  created_at          :datetime
#  updated_at          :datetime
#  bundle_file_name    :string(255)
#  bundle_content_type :string(255)
#  bundle_file_size    :integer
#  bundle_updated_at   :datetime
#

class Paper < ActiveRecord::Base
	has_paper_trail
	has_attached_file :bundle,
										path: ENV["PAPERCLIP_PATH"] + "/:class/bundle/:course_type/:course_id/:filename",
										preserve_files: true
	validates_attachment_content_type :bundle, content_type: "application/pdf"
	validates_attachment_presence :bundle
	validates :name, presence: true

	belongs_to :course
	before_post_process :renaming_bundle_file


	Paperclip.interpolates :course_id do |bundle, style|
		bundle.instance.course_id
	end

	Paperclip.interpolates :course_type do |bundle, style|
		bundle.instance.course.type
	end

	private
  def renaming_bundle_file
  	ext = File.extname(bundle_file_name).downcase
    self.bundle.instance_write :file_name, "#{Time.now.to_i.to_s}#{ext}"
  end
end
