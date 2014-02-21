# == Schema Information
#
# Table name: faculties
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  website           :string(255)
#  departments_count :integer          default(0)
#  staffs_count      :integer          default(0)
#  created_at        :datetime
#  updated_at        :datetime
#

class Faculty < ActiveRecord::Base
	has_many :departments, dependent: :destroy
	has_many :staffs, dependent: :destroy
	validates :name, presence: true, uniqueness: true
end
