# == Schema Information
#
# Table name: feedbacks
#
#  id            :integer          not null, primary key
#  content       :text             not null
#  course_id     :integer          not null
#  userable_id   :integer          not null
#  userable_type :string(255)      not null
#  created_at    :datetime
#  updated_at    :datetime
#

class Feedback < ActiveRecord::Base
	belongs_to :course, counter_cache: true
	belongs_to :userable, :polymorphic => true

	validates :content, presence: true
	validates :course_id, presence: true
	validates :userable_id, presence: true
	validates :userable_type, presence: true
end
