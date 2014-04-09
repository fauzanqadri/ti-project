module Userable
	extend ActiveSupport::Concern

	included do

		has_one :user, as: :userable, dependent: :destroy
		has_one :avatar, as: :userable, dependent: :destroy
		
		accepts_nested_attributes_for :user, reject_if: :all_blank
		accepts_nested_attributes_for :avatar, reject_if: :all_blank
		
		validates :full_name, presence: true

		before_save :titleize_full_name

		after_create :make_user
		after_create :make_avatar

		delegate :email, :username, :socket_identifier, :userable_type, :userable_id, to: :user, allow_nil: true

	end

	class UserGenerator
		attr_accessor :userable

		def initialize userable
			@userable ||= userable
		end

		def username_builder
			@username_builder ||= userable.full_name.to_s.parameterize.underscore
		end

		def users
			@users ||= User.where{(username =~ "%#{username_builder}%")}
		end

		def final_username
			return username_builder if users.nil? || users.blank?
			"#{username_builder}#{user.size}"
		end

		def email
			"#{final_username}@mail.me"
		end

		def password
			return userable.nim if userable.class == Student
			return "#{username_builder}12345678"
		end

		def primary_identification
			return userable.nim if userable.class == Student
			return userable.nip if userable.class == Lecturer
			return nil if userable.class == Staff
		end

		def secondary_identification
			return nil if userable.class == Student
			return userable.nid if userable.class == Lecturer
			return nil if userable.class == Staff
		end

	end

	def to_s
		self.full_name
	end

	def to_param
		"#{self.id}-#{self.full_name.parameterize}"
	end

	def reset_user
		make_user unless self.user
	end

	def reset_password
		generator = UserGenerator.new(self)
		unless self.user
			make_user
		else
			user = self.user
			user.password = generator.password
			user.password_confirmation = generator.password
			user.save
		end
	end

	private
	def make_avatar
		self.create_avatar if self.avatar.nil?
	end

	def make_user
		generator = UserGenerator.new(self)
		user = self.build_user(
			email: generator.email, 
			username: generator.final_username, 
			primary_identification: generator.primary_identification,
			secondary_identification: generator.secondary_identification,
			password: generator.password, 
			password_confirmation: generator.password
		)
		user.save
	end

	def titleize_full_name
		self.full_name = self.full_name.titleize
	end

end