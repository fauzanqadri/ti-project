# == Schema Information
#
# Table name: examiners
#
#  id          :integer          not null, primary key
#  sidang_id   :integer          not null
#  lecturer_id :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#

class Examiner < ActiveRecord::Base
	has_paper_trail
	belongs_to :sidang
	belongs_to :lecturer
	has_one :surcease, as: :provenable, dependent: :destroy
	validates :lecturer_id, presence: true
	after_save :create_surcease_course

	private

	def create_surcease_course
		if !self.surcease
			crs_id = self.sidang.skripsi.id
			src = self.build_surcease(course_id: crs_id)
			src.save
		end
	end


end
