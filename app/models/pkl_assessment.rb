class PklAssessment < ActiveRecord::Base
	CATEGORY = ["Penulisan", "Aktifitas"]
	has_paper_trail
	belongs_to :department
	validates_presence_of :aspect, :category, :department_id
	validates_inclusion_of :category, in: CATEGORY
end