# == Schema Information
#
# Table name: imports
#
#  id                         :integer          not null, primary key
#  klass_action               :string(255)
#  created_at                 :datetime
#  updated_at                 :datetime
#  package_file_name          :string(255)
#  package_content_type       :string(255)
#  package_file_size          :integer
#  package_updated_at         :datetime
#  total_row                  :integer          default(0), not null
#  status                     :string(255)      default("on progress"), not null
#  department_id              :integer
#  userable_id                :integer          not null
#  userable_type              :string(255)      not null
#  package_original_file_name :string(255)      default(""), not null
#

class Import < ActiveRecord::Base
	KLASS_ACTION = ["Student"]
	STATUS = ["on progress", "extracting", "complete", "fail"]
	has_attached_file :package, 
										path: ENV["PAPERCLIP_PATH"] + "/:class/package/:klass_action/:filename"

	belongs_to :userable, polymorphic: true
	belongs_to :department
	# validates_attachment_content_type :package, content_type: {content_type: ["application/vnd.ms-excel", "text/csv", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"]}
	validates_attachment_presence :package
	validates :klass_action, presence: true
	validates :department_id, presence: true, if: :userable_condition?
	validates :status, inclusion: { in: STATUS }

	before_post_process :renaming_package_file
	before_create :set_file_ownership

	after_commit :populate_imported_file, on: :create
	after_commit :push_notification, on: :update

	act_as_importir

	scope :by_department, -> (d_id) {where{department_id.eq(d_id)}}
	scope :by_faculty, -> (f_id) { joins(department).where{(department.faculty_id.eq(f_id)) } }

	Paperclip.interpolates :klass_action do |package, style|
		package.instance.klass_action
	end

	def remove_imported_data
		im_id = self.id
		self.klass_action.classify.constantize.where{ (import_id.eq(im_id) )}.destroy_all
	end

	private
	def renaming_package_file
		self.package_original_file_name = self.package_file_name
		ext = File.extname(package_file_name).downcase
    self.package.instance_write :file_name, "#{Time.now.to_i.to_s}#{ext}"
	end

	def set_file_ownership
		if self.userable_type == "Lecturer"
			self.department_id = self.userable.department_id
		end
	end

	def populate_imported_file
		self.populate
	end

	def userable_condition?
		self.userable_type == "Staff"
	end

	def push_notification
		if self.status == "complete"
			data = {
				command: "renderFlash", 
				args: { 
					status: "notice", 
					message: "Import data telah berhasil #{self.total_row} telah di import untuk data #{self.klass_action.downcase}" 
				},
				type: "private",
				socket_identifier: self.userable.user.socket_identifier
			}
			self.broadcast("/main_channel", data)
		end
	end
end
