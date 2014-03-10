# == Schema Information
#
# Table name: departments
#
#  id                                 :integer          not null, primary key
#  name                               :string(255)
#  website                            :text
#  faculty_id                         :integer          not null
#  students_count                     :integer          default(0)
#  lecturers_count                    :integer          default(0)
#  created_at                         :datetime
#  updated_at                         :datetime
#  concentrations_count               :integer          default(0)
#  director_manage_seminar_scheduling :boolean          default(TRUE), not null
#  director_manage_sidang_scheduling  :boolean          default(FALSE), not null
#  director_set_local_seminar         :boolean          default(FALSE), not null
#  director_set_local_sidang          :boolean          default(FALSE), not null
#

class Department < ActiveRecord::Base
	belongs_to :faculty, counter_cache: true
  has_many :concentrations, dependent: :destroy
  has_many :students, dependent: :destroy
  has_many :lecturers, dependent: :destroy
  has_many :assessments, dependent: :destroy
  has_one :setting, dependent: :destroy
  validates :name, presence: true, uniqueness: {scope: [:faculty_id, :name]}
  validates :faculty_id, presence: true
  after_create :reset_setting

  private
  def reset_setting
  	self.build_setting.save
  end
end
