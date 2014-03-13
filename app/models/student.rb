# == Schema Information
#
# Table name: students
#
#  id             :integer          not null, primary key
#  nim            :string(255)      default(""), not null
#  full_name      :string(255)      default(""), not null
#  address        :text
#  born           :date
#  student_since  :date
#  department_id  :integer          default(0), not null
#  pkls_count     :integer          default(0)
#  skripsis_count :integer          default(0)
#  created_at     :datetime
#  updated_at     :datetime
#

class Student < ActiveRecord::Base
	has_one :user, as: :userable, dependent: :destroy
	belongs_to :department, counter_cache: true
	has_many :courses, dependent: :destroy
	has_many :skripsis
	has_many :pkls
	has_many :assigned_supervisors, as: :userable, class_name: "Supervisor"
	has_many :feedbacks, as: :userable
	has_many :conference, as: :userable, dependent: :destroy
	has_one :avatar, as: :userable, dependent: :destroy
	accepts_nested_attributes_for :user, reject_if: :all_blank
	accepts_nested_attributes_for :avatar, reject_if: :all_blank
	validates_presence_of :born
	validates_presence_of :department_id
	validates :nim, presence: true, uniqueness: true
	validates :full_name, presence: true, uniqueness: {scope: [:nim, :department_id] }
	after_create :reset_user
	after_create :build_avatar

	scope :by_faculty, ->(id){ joins{department}.where{department.faculty_id.eq(id)}}

	def to_params
		"#{self.id}-#{self.full_name.parameterize}"
	end

	def to_s
		self.full_name
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
		email = "#{username}@mail.me"
		password = self.nim
		primary_identification = self.nim
		user = self.build_user(
														email: email, 
														username: username,
														primary_identification: primary_identification,  
														password: password, 
														password_confirmation: password
													)
		user.save
	end
	
	private
	def build_avatar
		self.create_avatar if self.avatar.nil?
	end
end
