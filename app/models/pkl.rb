# == Schema Information
#
# Table name: courses
#
#  id                :integer          not null, primary key
#  title             :string(255)      default(""), not null
#  description       :text
#  concentration_id  :integer
#  student_id        :integer          not null
#  type              :string(255)      default(""), not null
#  supervisors_count :integer          default(0), not null
#  created_at        :datetime
#  updated_at        :datetime
#  feedbacks_count   :integer          default(0), not null
#  is_finish         :boolean          default(FALSE)
#

class Pkl < Course
	belongs_to :student, :counter_cache => true
	after_save :check_is_finish_status

	private
	def check_is_finish_status
		if self.is_finish_changed?
			if self.is_finish?
				self.supervisors.approved_supervisors.each do |spv|
					Lecturer.decrement_counter(:supervisors_pkl_count, spv.lecturer_id)
				end
			else
				self.supervisors.approved_supervisors.each do |spv|
					Lecturer.increment_counter(:supervisors_pkl_count, spv.lecturer_id)
				end
			end
		end
	end
end
