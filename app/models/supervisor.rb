# == Schema Information
#
# Table name: supervisors
#
#  id            :integer          not null, primary key
#  course_id     :integer          not null
#  lecturer_id   :integer          not null
#  approved      :boolean          default(FALSE), not null
#  userable_type :string(255)      default(""), not null
#  userable_id   :integer          not null
#  created_at    :datetime
#  updated_at    :datetime
#

class Supervisor < ActiveRecord::Base
	belongs_to :course
	belongs_to :lecturer
	belongs_to :userable, :polymorphic => true
	has_many :consultations, as: :consultable, dependent: :destroy
	has_many :conference_logs, dependent: :destroy
	validates_presence_of :course_id, :lecturer_id
	validates :lecturer_id, uniqueness: {scope: :course_id, message: "Telah menjadi / ditugaskan sebagai pembimbing pada skripsi / pkl ini"} 
	validate :lecturer_lead_coures_rule, :supervisor_course_amount, :maximum_lecturer_course_lead
	before_save :set_approval
	
	after_save :update_lecturer_counter_cache
	after_save :update_course_counter_cache
	after_destroy :update_lecturer_counter_cache
	after_destroy :update_course_counter_cache

	scope :approved_supervisors, -> {where{(approved == true)} }
	default_scope {order('created_at asc')}

	private
	def update_lecturer_counter_cache
		l_id = self.lecturer_id
		supervisors = Supervisor.where{(approved == true) & (lecturer_id == l_id)}
		self.lecturer.supervisors_count = supervisors.count
		if self.course.class == Skripsi
			self.lecturer.supervisors_skripsi_count += 1 if self.approved? && self.persisted?
			self.lecturer.supervisors_skripsi_count -= 1 unless self.persisted?
		else
			self.lecturer.supervisors_pkl_count += 1 if self.approved? && self.persisted?
			self.lecturer.supervisors_pkl_count -= 1 unless self.persisted?
		end
		self.lecturer.save
	end

	def update_course_counter_cache
		if self.approved? && self.persisted?
			self.course.supervisors_count += 1
			self.course.save
		else
			self.course.supervisors_count -= 1
			self.course.save
		end
	end

	def set_approval
		self.approved = true if self.userable_id == self.lecturer_id
	end

	def supervisor_course_amount
		department_supervisor_course_amount = self.course.type == "Skripsi" ? self.course.student.department.setting.supervisor_skripsi_amount : self.course.student.department.setting.supervisor_pkl_amount
		errors.add(:course_id, " ini telah memiliki batas jumlah pembimbing yang telah ditentukan") if self.course.supervisors.size >= department_supervisor_course_amount
	end

	def maximum_lecturer_course_lead
		if self.lecturer_id.present?
			if self.course.type == "Skripsi"
				department_maximum_lecturer_course_lead = self.lecturer.level == "Lektor" ? self.course.student.department.setting.maximum_lecturer_lektor_skripsi_lead : self.course.student.department.setting.maximum_lecturer_aa_skripsi_lead
				if department_maximum_lecturer_course_lead == 0
					return true
				else
					errors.add(:lecturer_id, " telah memiliki batas jumlah skripsi / pkl yang boleh di bimbing") if self.lecturer.supervisors_skripsi_count >= department_maximum_lecturer_course_lead
				end
			else
				department_maximum_lecturer_course_lead = self.lecturer.level == "Lektor" ? self.course.student.department.setting.maximum_lecturer_lektor_pkl_lead : self.course.student.department.setting.maximum_lecturer_aa_pkl_lead
				if department_maximum_lecturer_course_lead == 0
					return true
				else
					errors.add(:lecturer_id, " telah memiliki batas jumlah skripsi / pkl yang boleh di bimbing") if self.lecturer.supervisors_pkl_count >= department_maximum_lecturer_course_lead
				end
			end
		end
	end

	def rules_check? rule
		approved_level = self.course.supervisors.where{(approved == true)}.includes(:lecturer).collect{|supervisor| supervisor.lecturer.level}
		supervisor_level = self.lecturer.level
		case rule 
		when 'only_lektor'
			return true if supervisor_level == 'Lektor'
			return false
		when 'only_aa'
			return true if supervisor_level == 'Asisten Ahli'
			return false
		when 'lektor_first_then_aa'
			appended = approved_level << supervisor_level
			return true if appended.size == 1 && appended[0] == 'Lektor'
			return true if appended.size > 1 && appended[0] == 'Lektor' && !appended[1..appended.size].include?("Lektor")
			return false
		when 'aa_first_then_lektor'
			appended = approved_level << supervisor_level
			return true if appended.size == 1 && appended[0] == 'Asisten Ahli'
			return true if appended.size > 1 && appended[0] == 'Asisten Ahli' && !appended[1..appended.size].include?('Asisten Ahli')
			return false
		when 'lektor_first_then_free'
			appended = approved_level << supervisor_level
			return true if appended.size == 1 && appended[0] == 'Lektor'
			return true if appended.size > 1 && appended[0] == 'Lektor'
			return false
		when 'aa_first_then_free'
			appended = approved_level << supervisor_level
			return true if appended.size == 1 && appended[0] == 'Asisten Ahli'
			return true if appended.size > 1 && appended[0] == 'Asisten Ahli'
			return false
		when 'free'
			return true
		else
			return false
		end
	end

	def lecturer_lead_coures_rule
		if self.course.type == "Skripsi"
			department_lecturer_lead_course_rule = self.course.student.department.setting.lecturer_lead_skripsi_rule
		else
			department_lecturer_lead_course_rule = self.course.student.department.setting.lecturer_lead_pkl_rule
		end
		errors.add(:lecturer_id, "Level dosen belum terpenuhi untuk melakakukan pembimbingan skripsi / pkl ini") unless rules_check?(department_lecturer_lead_course_rule)
	end
end
