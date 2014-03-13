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
	LEVEL = ["Lektor", "Asisten Ahli"]
	has_one :user, as: :userable, dependent: :destroy
	belongs_to :department, counter_cache: true
	has_many :supervisors, dependent: :destroy
	has_many :assigned_supervisors, as: :userable, class_name: "Supervisor", dependent: :destroy
	has_many :feedbacks, as: :userable, dependent: :destroy
	has_many :conference, as: :userable, dependent: :destroy
	has_many :conference_logs, through: :supervisors
	has_many :examiners, dependent: :destroy
	has_one :avatar, as: :userable, dependent: :destroy
	accepts_nested_attributes_for :user, reject_if: :all_blank
	accepts_nested_attributes_for :avatar, reject_if: :all_blank
	validates :level, presence: true, inclusion: {in: LEVEL}
	validates :department_id, presence: true
	validates :full_name, presence: true
	validates :born, presence: true
	validates :full_name, uniqueness: {scope: [:department_id, :born, :nip, :nid]}
	after_create :reset_user
	after_save :update_user_attributes
	after_create :build_avatar

	scope :by_faculty, ->(id) { joins{department}.where{department.faculty_id.eq(id)} }
	scope :search, ->(query) {where{(full_name =~ "%#{query}%")}}

	def to_param
		"#{self.id}-#{self.full_name.parameterize}"
	end

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

	# <-------------------------------------------------- Callback -------------------------------------------------->
	def reset_user
		self.user.destroy unless self.user.nil?
		u = User.find_by_username(self.full_name.to_s.parameterize.underscore)
		username = if u.blank?
			self.full_name.to_s.parameterize.underscore
		else
			"#{self.full_name.to_s.parameterize.underscore}#{u.size}"
		end
		password = if !self.nip.nil? || !self.nip.blank?
			self.nip
		elsif !self.nid.nil? || !self.nid.blank?
			self.nid
		elsif !(self.nip.nil? || self.nip.blank?) && !(self.nid.nil? || self.nid.blank?)
			self.nip
		else
			"#{username}12345678"
		end
		email = "#{username}@mail.me"
		primary_identification = self.nip
		secondary_identification = self.nid
		user = self.build_user(
														email: email, 
														username: username,
														primary_identification: primary_identification, 
														secondary_identification: secondary_identification,
														password: password, 
														password_confirmation: password
													)
		user.save
	end

	private
	def update_user_attributes
		self.user.primary_identification = self.nip if self.nip_changed?
		self.user.secondary_identification = self.nid if self.nid_changed?
		self.user.save
	end

	def build_avatar
		self.create_avatar if self.avatar.nil?
	end
	
end
