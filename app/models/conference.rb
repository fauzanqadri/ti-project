# == Schema Information
#
# Table name: conferences
#
#  id                           :integer          not null, primary key
#  local                        :string(255)
#  start                        :datetime
#  end                          :datetime
#  skripsi_id                   :integer          not null
#  type                         :string(255)      not null
#  userable_id                  :integer          not null
#  userable_type                :string(255)      not null
#  supervisor_approval          :boolean          default(FALSE), not null
#  created_at                   :datetime
#  updated_at                   :datetime
#  department_director_approval :boolean          default(FALSE)
#

class Conference < ActiveRecord::Base
	TYPE = ["Seminar", "Sidang"]
	belongs_to :skripsi
	belongs_to :userable, polymorphic: true
	has_many :conference_logs, dependent: :destroy
	validates :skripsi_id, presence: true
	validates :userable_id, presence: true
	validates :userable_type, presence: true
	validates :type, presence: true, inclusion: {in: TYPE}
	validates_uniqueness_of :skripsi_id, scope: :type, message: "Skripsi ini telah mendaftarkan sidang / seminar sebelumnya"

	validate :ready_registration, on: :create
	after_create :build_logs

	scope :by_department, ->(d_id) { joins{skripsi.student}.where{(students.department_id == d_id)} }
	scope :by_faculty, -> (f_id) { joins{skripsi.student.department}.where{(departments.faculty_id == f_id)} }
	scope :approved_supervisors, -> { where{(supervisor_approval == true)}}
	scope :unapprove_department_director, -> { where{department_director == false} }
	scope :approved_department_director, -> { where{(department_director_approval == true)} }
	scope :scheduled, -> {where{(start != nil) | (conferences.end != nil)}}
	scope :unscheduled, -> {where{(start == nil) & (conferences.end == nil)}}

	def status
		if !self.supervisor_approval?
			havent_confirm = self.conference_logs.where{(approved == false)}.size
			return "Menunggu persetujuan #{havent_confirm} dosen pembimbing"
		elsif !self.local?
			return "Menunggu ruangan"
		else
			return "Disetujui"
		end
		
	end

	def tanggal
		self.start.try(:strftime, "%A, %d %B %Y")
	end

	def mulai
		self.start.try(:strftime, "%H:%M")
	end

	def selesai
		self.end.try(:strftime, "%H:%M")
	end

	def color
		if self.local? && self.department_director_approval?
			"green"
		elsif !self.local? && self.department_director_approval?
			"orange"
		else
			"red"
		end
	end

	private
	def ready_registration
		supervisors_count = self.skripsi.supervisors_count
		papers_count = self.skripsi.papers.size
		consultations_count = self.skripsi.consultations.size
		setting = self.skripsi.student.department.setting.supervisor_skripsi_amount
		errors.add(:skripsi_id, "belum siap untuk didaftarkan seminar / sidang") if (papers_count <= 1) || (consultations_count <= 1) || (supervisors_count < setting)
	end

	def build_logs
		supervisors = self.skripsi.supervisors.where{approved == true}
		supervisors.each do |supervisor|
			approved = supervisor.lecturer_id == self.userable_id ? true : false
			log = supervisor.conference_logs.build({conference: self, approved: approved})
			log.save
		end
	end
end
