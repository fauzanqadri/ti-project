# == Schema Information
#
# Table name: students
#
#  id             :integer          not null, primary key
#  nim            :string(255)      default(""), not null
#  full_name      :string(255)      default(""), not null
#  address        :text
#  born           :date
#  department_id  :integer          default(0), not null
#  pkls_count     :integer          default(0)
#  skripsis_count :integer          default(0)
#  created_at     :datetime
#  updated_at     :datetime
#  student_since  :integer
#  sex            :string(2)
#  home_number    :string(255)
#  phone_number   :string(255)
#  import_id      :integer
#

class Student < ActiveRecord::Base
	include Userable
	belongs_to :department, counter_cache: true

	has_many :courses, dependent: :destroy
	has_many :skripsis, dependent: :destroy
	has_many :pkls, dependent: :destroy

	has_many :assigned_supervisors, as: :userable, class_name: "Supervisor"
	has_many :feedbacks, as: :userable
	has_many :conference, as: :userable, dependent: :destroy
	

	validates_presence_of :department_id
	validates :nim, presence: true, uniqueness: true
	validates :full_name, uniqueness: { scope: :nim }

	delegate_import_attr nim: {key: "NIMHSMSMH", required: true}, full_name: { key: "NMMHSMSMH", required: true}, address: { key: "ALMHSMSMH", required: false}, student_since: { key: "TAHUNMSMH", required: false}, home_number: {key: "TELRMMSMH", required: false}, phone_number: { key: "NOHPPMSMH", required: false}
	delegate_copy_importir_attr :department_id, required: true, to: :department_id
	delegate_copy_importir_attr :import_id, required: true, to: :id

	scope :by_faculty, ->(f_id){ joins{department}.where{department.faculty_id.eq(f_id)} }
	scope :by_department, ->(d_id) { where{department_id.eq(d_id)} }
	scope :search, ->(query) { where{(full_name =~ "%#{query}%") | (nim =~ "#{query}") } }

end
