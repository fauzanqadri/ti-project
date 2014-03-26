# == Schema Information
#
# Table name: lecturers
#
#  id                        :integer          not null, primary key
#  nip                       :string(255)
#  nid                       :string(255)
#  full_name                 :string(255)      default(""), not null
#  address                   :text
#  born                      :date
#  level                     :string(255)      default("Lektor"), not null
#  front_title               :string(255)
#  back_title                :string(255)
#  is_admin                  :boolean          default(FALSE)
#  department_id             :integer
#  created_at                :datetime
#  updated_at                :datetime
#  supervisors_count         :integer          default(0), not null
#  supervisors_pkl_count     :integer          default(0), not null
#  supervisors_skripsi_count :integer          default(0), not null
#

class Lecturer < ActiveRecord::Base
	include Userable
	LEVEL = ["Lektor", "Asisten Ahli"]
	has_paper_trail

	belongs_to :department, counter_cache: true

	has_many :supervisors, dependent: :destroy
	has_many :assigned_supervisors, as: :userable, class_name: "Supervisor", dependent: :destroy
	has_many :feedbacks, as: :userable, dependent: :destroy
	has_many :conference, as: :userable, dependent: :destroy
	has_many :conference_logs, through: :supervisors
	has_many :examiners, dependent: :destroy
	has_many :imports, as: :userable, dependent: :nullify

	validates :level, presence: true, inclusion: {in: LEVEL}
	validates :department_id, presence: true
	
	validates :full_name, uniqueness: {scope: [:nip, :nid] }
	after_save :update_user_attributes

	scope :by_faculty, ->(id) { joins{department}.where{department.faculty_id.eq(id)} }
	scope :by_department, ->(d_id) {where{department_id.eq(d_id)}}
	scope :search, ->(query) {where{ (full_name =~ "%#{query}%") | (nip =~ "%#{query}%") | (nid =~ "#{query}") }}

	def to_s
		front = self.front_title.blank? ? "" : "#{self.front_title}."
		back = self.back_title.blank? ? "" : ", #{self.back_title}"
		[front, self.full_name, back].join("")
	end

	def rest_of_supervison_of_skripsi
		maximum_allowed_supervison_of_skripsi = self.level == "Lektor" ? self.department.setting.maximum_lecturer_lektor_skripsi_lead : self.department.setting.maximum_lecturer_aa_skripsi_lead
		if maximum_allowed_supervison_of_skripsi == 0
			"∞"
		else
			maximum_allowed_supervison_of_skripsi - self.supervisors_skripsi_count
		end
	end

	def rest_of_supervison_of_pkl
		maximum_allowed_supervison_of_pkl = self.level == "Lektor" ? self.department.setting.maximum_lecturer_lektor_pkl_lead : self.department.setting.maximum_lecturer_aa_pkl_lead
		if maximum_allowed_supervison_of_pkl == 0
			"∞"
		else
			maximum_allowed_supervison_of_pkl - self.supervisors_pkl_count
		end
	end

	private
	def update_user_attributes
		self.user.primary_identification = self.nip if self.nip_changed?
		self.user.secondary_identification = self.nid if self.nid_changed?
		self.user.save
	end

end
