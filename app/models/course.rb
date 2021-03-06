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

class Course < ActiveRecord::Base
	has_paper_trail
	belongs_to :student
	belongs_to :concentration
	has_many :papers, dependent: :destroy
	has_many :supervisors, dependent: :destroy
	has_many :feedbacks, dependent: :destroy
	has_many :consultations, dependent: :destroy
	has_many :surceases, dependent: :destroy
	has_many :reports, dependent: :destroy
	accepts_nested_attributes_for :papers
	validates :description, presence: true
	validates :title, presence: true
	validates :student_id, presence: true

	scope :by_department, ->(id){ joins{student}.where{(student.department_id.eq(id))} }
	scope :by_faculty, ->(f_id) { joins{student.department}.where{(departments.faculty_id == f_id)} }
	scope :by_concentration, ->(c_id) { where{concentration_id == c_id} }
	
	scope :search, ->(query){joins{student.department}.joins{concentration}.where{(student.full_name =~ "%#{query}%") | (student.nim =~ "%#{query}%") | (title =~ "%#{query}%")}}
	scope :published_search, ->(query) { joins{student}.where{(student.full_name =~ "%#{query}%") | (student.nim =~ "%#{query}%")} }
	scope :is_finish, -> {where{(is_finish == true)}}
	scope :by_type, ->(typ) { where{(type == typ)} }
	scope :by_student, ->(s_id) { where{ (student_id.eq(s_id)) } }
	scope :by_lecturer, ->(l_id) { joins{supervisors}.where{ (supervisors.lecturer_id.eq(l_id)) } }
	scope :by_supervisor, ->(lecturer_name) { joins{supervisors.lecturer}.where{(lecturers.full_name =~ "%#{lecturer_name}%")} }
	scope :approved_by_lecturer, ->(l_id) { by_lecturer(l_id).where{ (supervisors.approved == true ) } }
	scope :request_to_lecturer, ->(l_id) { by_lecturer(l_id).where{ (supervisors.approved == false) } }

	default_scope {order('created_at desc')}

end
