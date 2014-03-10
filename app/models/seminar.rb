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

class Seminar < Conference

	before_create :set_seminars_durations
	
	private
	def set_seminars_durations
		self.end = self.start + 1.hour
	end
end
