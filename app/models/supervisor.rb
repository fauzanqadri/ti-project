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
	has_paper_trail
	belongs_to :course
	belongs_to :lecturer
	belongs_to :userable, :polymorphic => true
	has_many :consultations, as: :consultable, dependent: :destroy
	has_many :conference_logs, dependent: :destroy
	has_one :surcease, as: :provenable, dependent: :destroy
	validates_presence_of :course_id, :lecturer_id
	validates :lecturer_id, uniqueness: {scope: :course_id, message: "Telah menjadi / ditugaskan sebagai pembimbing pada skripsi / pkl ini"} 

	validate :lecturer_lead_coures_rule, :supervisor_course_amount, :maximum_lecturer_course_lead	

	before_validation(on: :create) do 
		self.approved = true if (self.userable_id == self.lecturer_id && self.userable_type == "Lecturer") || (self.userable_id == self.course.student.department.setting.department_director && self.userable_type == "Lecturer")
	end
	
	after_save :create_surcease_course
	after_commit :increment_global_lecturer_counter_cache, on: :create
	after_commit :decrement_global_lecturer_counter_cache, on: :destroy

	after_commit :increment_lecturer_counter_cache, on: [:create, :update]
	after_commit :decrement_lecturer_counter_cache, on: [:destroy, :update]

	after_commit :increment_course_counter_cache, on: [:create, :update]
	after_commit :decrement_course_counter_cache, on: :destroy

	before_save :set_approved_time
	after_save :send_notification
	after_destroy :send_destroy_notification

	scope :approved_supervisors, -> {where{(approved == true)} }
	default_scope {order('approved_time asc')}

	def status
		return "Menunggu Persetujuan" unless self.approved?
		"Disetujui"
	end

	private

	def increment_global_lecturer_counter_cache
		Lecturer.increment_counter(:supervisors_count, self.lecturer_id) if self.approved?
	end

	def decrement_global_lecturer_counter_cache
		Lecturer.decrement_counter(:supervisors_count, self.lecturer_id) if self.approved? && self.lecturer.supervisors_count > 0
	end

	def increment_lecturer_counter_cache
		if self.course.class == Skripsi
			Lecturer.increment_counter(:supervisors_skripsi_count, self.lecturer_id) if self.approved?
		else
			Lecturer.increment_counter(:supervisors_pkl_count, self.lecturer_id) if self.approved?
		end
	end

	def decrement_lecturer_counter_cache
		if self.course.class == Skripsi
			Lecturer.decrement_counter(:supervisors_skripsi_count, self.lecturer_id) if self.lecturer.supervisors_skripsi_count > 0 && self.approved?
		else
			Lecturer.decrement_counter(:supervisors_pkl_count, self.lecturer_id) if self.lecturer.supervisors_skripsi_count > 0 && self.approved?
		end
	end

	def increment_course_counter_cache
		Course.increment_counter(:supervisors_count, self.course_id) if self.approved?
		if self.course.supervisors_count > 0
			Course.decrement_counter(:supervisors_count, self.course_id) if self.approved_changed? && !self.approved?
		end
	end

	def decrement_course_counter_cache
		Course.decrement_counter(:supervisors_count, self.course_id) if self.course.supervisors_count > 0 && self.approved?
	end

	def create_surcease_course
		if !self.surcease && self.approved?
			crs_id = self.course_id
			src = self.build_surcease(course_id: crs_id)
			src.save
		elsif self.surcease && !self.approved?
			self.surcease.destroy
		end
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
					unless self.userable_id == self.course.student.department.setting.department_director && self.userable_type == "Lecturer"
						errors.add(:lecturer_id, " telah memiliki batas jumlah skripsi / pkl yang boleh di bimbing") if self.lecturer.supervisors_skripsi_count >= department_maximum_lecturer_course_lead
					end
				end
			else
				department_maximum_lecturer_course_lead = self.lecturer.level == "Lektor" ? self.course.student.department.setting.maximum_lecturer_lektor_pkl_lead : self.course.student.department.setting.maximum_lecturer_aa_pkl_lead
				if department_maximum_lecturer_course_lead == 0
					return true
				else
					unless self.userable_id == self.course.student.department.setting.department_director && self.userable_type == "Lecturer"
						errors.add(:lecturer_id, " telah memiliki batas jumlah skripsi / pkl yang boleh di bimbing") if self.lecturer.supervisors_pkl_count >= department_maximum_lecturer_course_lead
					end
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

		unless self.userable_id == self.course.student.department.setting.department_director && self.userable_type == "Lecturer"
			errors.add(:lecturer_id, "Persyaratan peraturan level dosen belum terpenuhi untuk melakakukan pembimbingan skripsi / pkl ini") if ( !rules_check?(department_lecturer_lead_course_rule) && self.approved? ) 
		end
	end

	def set_approved_time
		self.approved_time = Time.now if self.approved?
	end

	def send_notification
		lecturer_notification
		student_notification
	end

	def lecturer_notification
		current_message = {
			command: "renderFlash",
			type: "private",
			socket_identifier: self.lecturer.try(:socket_identifier)
		}
		data = if self.approved?
			current_message.merge(
				args: {
					status: "notice",
					message: "Kamu telah menyetujui menjadi pembimbing #{self.course.class.to_s.downcase}"
				}
			)
		else
			current_message.merge(
				args: {
					status: "warning",
					message: "Seseorang telah meminta kamu menjadi pembimbing #{self.course.class.to_s.downcase}"
				}
			)
		end
		self.broadcast("/main_channel", data)
	end

	def student_notification
		if self.approved?
			data = {
				command: "renderFlash", 
				args: { 
					status: "notice", 
					message: "#{self.course.class.to_s} kamu telah memiliki pembimbing" 
				},
				type: "private",
				socket_identifier: self.course.student.try(:socket_identifier)
			}
			self.broadcast("/main_channel", data)
		end
	end

	def send_destroy_notification
		if self.course.student.persisted?
			data = {
				command: "renderFlash", 
				args: { 
					status: "alert", 
					message: "Pembimbingan pada #{self.course.class.to_s.downcase} dibatalkan" 
				},
				type: "private",
				socket_identifier: self.course.student.try(:socket_identifier)
			}
			self.broadcast("/main_channel", data)
		end
	end
end
