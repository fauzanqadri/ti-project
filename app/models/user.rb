# == Schema Information
#
# Table name: users
#
#  id                       :integer          not null, primary key
#  email                    :string(255)      default(""), not null
#  username                 :string(255)      default(""), not null
#  primary_identification   :string(255)
#  secondary_identification :string(255)
#  encrypted_password       :string(255)      default(""), not null
#  reset_password_token     :string(255)
#  reset_password_sent_at   :datetime
#  remember_created_at      :datetime
#  sign_in_count            :integer          default(0), not null
#  current_sign_in_at       :datetime
#  last_sign_in_at          :datetime
#  current_sign_in_ip       :string(255)
#  last_sign_in_ip          :string(255)
#  userable_type            :string(255)      default(""), not null
#  userable_id              :integer          not null
#  created_at               :datetime
#  updated_at               :datetime
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  attr_accessor :login
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:login]
  validates :username, uniqueness: { case_sensitive: false }

  belongs_to :userable, polymorphic: true

  def self.find_first_by_auth_conditions(warden_conditions)
  	conditions = warden_conditions.dup
  	if login = conditions.delete(:login)
  		where(conditions).where{(email == login.downcase) | (username == login.downcase) | (primary_identification == login.downcase) | (secondary_identification == login.downcase)}.first
  		# where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
  	else
  		where(conditions).first
  	end
  end
end
