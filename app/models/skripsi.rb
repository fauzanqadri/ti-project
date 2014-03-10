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

class Skripsi < Course
	belongs_to :student, :counter_cache => true
	has_many :conferences, dependent: :destroy
	has_one :seminar
	has_one :sidang
end
