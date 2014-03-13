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
	has_one :user, as: :userable, dependent: :destroy
	has_one :avatar, as: :userable, dependent: :destroy
	belongs_to :faculty, counter_cache: true
	accepts_nested_attributes_for :user, reject_if: :all_blank
	accepts_nested_attributes_for :avatar, reject_if: :all_blank
	validates_presence_of :full_name, :born, :faculty_id
	after_create :reset_user
	after_create :build_avatar

	def to_s
		self.full_name
	end


	# <-------------------------------------------------- Callback -------------------------------------------------->

	def reset_user
		self.user.destroy unless self.user.nil?
		u = User.find_by_username(self.full_name.to_s.parameterize.underscore)
		username = if u.blank?
			self.full_name.to_s.parameterize.underscore
		else
			"#{self.full_name.to_s.parameterize.underscore}#{u.size}"
		end
		email = "#{username}@mail.me"
		password = "#{username}12345678"
		user = self.build_user(
														email: email, 
														username: username, 
														password: password, 
														password_confirmation: password
													)
		user.save
	end
	
	private
	def build_avatar
		self.create_avatar if self.avatar.nil?
	end
end
