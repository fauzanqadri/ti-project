# == Schema Information
#
# Table name: conference_logs
#
#  id            :integer          not null, primary key
#  conference_id :integer          not null
#  supervisor_id :integer          not null
#  approved      :boolean          default(FALSE), not null
#  created_at    :datetime
#  updated_at    :datetime
#

class ConferenceLog < ActiveRecord::Base
	belongs_to :conference
	belongs_to :supervisor
	validates :conference_id, presence: true
	validates :supervisor_id, presence: true

	after_save :set_conference_status
	after_save :recount_lecturer_supervisors_skripsi_count
	after_destroy :set_conference_status
	after_destroy :recount_lecturer_supervisors_skripsi_count

	def status
		if approved
			"Disetujui"
		else
			"Belum disetujui"
		end
	end

	def approve?
		# self.approved = true
		update(approved: true)
	end

	private
	def set_conference_status
		conference_logs_status = self.conference.conference_logs.pluck(:approved)
		if !conference_logs_status.include? false && self.persisted?
			self.conference.supervisor_approval = true
			self.conference.save
		elsif !self.persisted?
			self.conference.supervisor_approval = false
			self.conference.save
		end
	end

	def recount_lecturer_supervisors_skripsi_count
		setting = self.supervisor.lecturer.department.setting
		setting_value = self.supervisor.lecturer.level == "Lektor" ? setting.send(:maximum_lecturer_lektor_skripsi_lead) : setting.send(:maximum_lecturer_aa_skripsi_lead)
		if self.approved?() && self.supervisor.lecturer.supervisors_skripsi_count != 0 && self.supervisor.lecturer.supervisors_skripsi_count <= setting_value && self.conference.type == "Sidang"
			self.supervisor.lecturer.supervisors_skripsi_count -= 1
			self.supervisor.lecturer.save
		elsif self.approved? && self.conference.type == "Sidang" && !self.persisted?
			puts self.approved
			self.supervisor.lecturer.supervisors_skripsi_count += 1
			self.supervisor.lecturer.save
		end
	end

end
