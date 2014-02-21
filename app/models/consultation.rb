# == Schema Information
#
# Table name: consultations
#
#  id               :integer          not null, primary key
#  content          :text             not null
#  next_consult     :datetime
#  course_id        :integer          not null
#  consultable_id   :integer          not null
#  consultable_type :string(255)      not null
#  created_at       :datetime
#  updated_at       :datetime
#

class Consultation < ActiveRecord::Base
	belongs_to :course
	belongs_to :consultable, :polymorphic => true
	
	validates :content, presence: true, length: {maximum: 250}
	validates :consultable_id, presence: true
	validates :consultable_type, presence: true
end
