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

class Sidang < Conference
	has_many :examiners, dependent: :destroy
	accepts_nested_attributes_for :examiners, update_only: true
end
