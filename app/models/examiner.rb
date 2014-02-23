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
	belongs_to :sidang
	belongs_to :lecturer
end
