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
#

class Course < ActiveRecord::Base
	belongs_to :student
	belongs_to :concentration
	has_many :papers, dependent: :destroy
	has_many :supervisors, dependent: :destroy
	has_many :feedbacks, dependent: :destroy
	has_many :consultations, dependent: :destroy
	accepts_nested_attributes_for :papers
	validates :description, presence: true
	validates :title, presence: true
	validates :student_id, presence: true

	scope :by_department, ->(id){ joins{student}.where{(student.department_id.eq(id))} }
	scope :search, ->(query){joins{student.department}.joins{concentration}.where{(student.full_name =~ "%#{query}%") | (departments.name =~ "%#{query}%") | (concentration.name =~ "%#{query}%")}}
end
