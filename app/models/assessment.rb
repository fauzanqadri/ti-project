# == Schema Information
#
# Table name: assessments
#
#  id         :integer          not null, primary key
#  aspect     :text             not null
#  percentage :integer          not null
#  category   :string(255)      not null
#  version    :integer          default(1), not null
#  setting_id :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

class Assessment < ActiveRecord::Base
	CATEGORY = %w{Seminar Sidang}
	belongs_to :department
	validates :aspect, presence: true
	validates :percentage, presence: true, numericality: {only_integer: true, greater_than: 0, less_than: 100}
	validates :category, presence: true
	validates :category, inclusion: {in: Assessment::CATEGORY, message: "%{value} tidak valid"}
	validate :sum_of_aspect_percentage, on: :create
	default_scope  {order("percentage desc")}
	scope :by_category, ->(cat, dep_id){ where{(category.eq(cat)) & (department_id == dep_id)} }
	private
	def sum_of_aspect_percentage
		total_percentage = Assessment.by_category(self.category, self.department_id).pluck(:percentage).reduce(:+)
		total_percentage = total_percentage.nil? ? 0 : total_percentage
		errors.add(:percentage, "Kalkulasi Persentasi pada aspek penilaian melebihi 100") if ((total_percentage+self.percentage) > 100)  || total_percentage > 100
	end
end
