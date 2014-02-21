# == Schema Information
#
# Table name: concentrations
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  department_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Concentration < ActiveRecord::Base
	belongs_to :department, counter_cache: :concentrations_count
	has_many :courses, dependent: :nullify
	validates :name, presence: true, uniqueness: {scope: [:department_id, :name]}
  validates :department_id, presence: true
	scope :by_faculty, ->(faculty_id) {joins{:department}.where{(department.faculty_id == faculty_id)}}
end
