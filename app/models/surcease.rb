# == Schema Information
#
# Table name: surceases
#
#  id              :integer          not null, primary key
#  course_id       :integer          not null
#  provenable_type :string(255)      not null
#  provenable_id   :integer          not null
#  is_finish       :boolean          default(FALSE), not null
#  created_at      :datetime
#  updated_at      :datetime
#

class Surcease < ActiveRecord::Base
	belongs_to :course
	belongs_to :provenable, polymorphic: true
	delegate :lecturer, to: :provenable

	after_save :check_is_finish_status

	default_scope {order('created_at asc')}

	scope :by_lecturer, ->(l_id){
		joins(
			"LEFT JOIN supervisors on surceases.provenable_id = supervisors.\"id\" AND surceases.provenable_type = \'Supervisor\' LEFT JOIN examiners on surceases.provenable_id = examiners.\"id\" AND surceases.provenable_type = \'Examiner\'")
		.where{(supervisors.lecturer_id == l_id) | (examiners.lecturer_id == l_id)}
	}

	scope :search, ->(query){ joins{course.student}.where{(course.title =~ "%#{query}%") | (students.full_name =~ "%#{query}%") | (students.nim =~ "%#{query}%")} }
	scope :unfinish, -> {where{(is_finish == false)}}

	def approve
		self.update_attributes(is_finish: true)
	end

	def disapprove
		self.update_attributes(is_finish: false)
	end

	private
	def check_is_finish_status
		c_id = self.course_id
		status = Surcease.where{(course_id == c_id)}.pluck(:is_finish)
		if !status.include?(false)
			Course.find(c_id).update_attributes(is_finish: true)
		else
			Course.find(c_id).update_attributes(is_finish: false)
		end
	end
end
