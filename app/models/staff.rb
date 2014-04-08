# == Schema Information
#
# Table name: staffs
#
#  id          :integer          not null, primary key
#  full_name   :string(255)
#  address     :text
#  born        :date
#  staff_since :date
#  faculty_id  :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Staff < ActiveRecord::Base
	include Userable
	has_paper_trail
	has_many :imports, as: :userable, dependent: :nullify
	has_many :posts, as: :userable, dependent: :destroy
	belongs_to :faculty, counter_cache: true
	validates :faculty_id, presence: true
	
end
