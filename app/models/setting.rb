# == Schema Information
#
# Table name: settings
#
#  id                                   :integer          not null, primary key
#  supervisor_skripsi_amount            :integer          default(2), not null
#  supervisor_pkl_amount                :integer          default(1), not null
#  examiner_amount                      :integer          default(2), not null
#  maximum_lecturer_lektor_skripsi_lead :integer          default(10), not null
#  maximum_lecturer_aa_skripsi_lead     :integer          default(10), not null
#  allow_remove_supervisor_duration     :integer          default(3), not null
#  lecturer_lead_skripsi_rule           :string(255)      default("lektor_first_then_aa"), not null
#  lecturer_lead_pkl_rule               :string(255)      default("free"), not null
#  allow_student_create_pkl             :boolean          default(TRUE), not null
#  department_id                        :integer          not null
#  created_at                           :datetime
#  updated_at                           :datetime
#  maximum_lecturer_lektor_pkl_lead     :integer          default(0), not null
#  maximum_lecturer_aa_pkl_lead         :integer          default(0), not null
#  department_director                  :integer
#  department_secretary                 :integer
#

class Setting < ActiveRecord::Base
	belongs_to :department
	validates :supervisor_skripsi_amount, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 1}
	validates :supervisor_pkl_amount, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 1}
	validates :examiner_amount, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 1}
	validates :maximum_lecturer_lektor_skripsi_lead, presence: true, numericality: {only_integer: true}
	validates :maximum_lecturer_aa_skripsi_lead, presence: true, numericality: {only_integer: true}
	validates :allow_remove_supervisor_duration, presence: true, numericality: {only_integer: true}
	validates_presence_of :lecturer_lead_skripsi_rule, :lecturer_lead_pkl_rule, :lecturer_lead_pkl_rule, :allow_student_create_pkl, :department_id

	LECTURER_LEAD_SKRIPSI_RULE = [
		{
			:symbolic=> "only_lektor", 
			:description=> "Hanya dosen yang ber-level lektor"
		},
		{
			:symbolic=> "only_aa",
			:description=> "Hanya dosen yang ber-level Asisten Ahli"
		},
		{
			:symbolic=> "lektor_first_then_aa",
			:description=> "Dosen ber-level lektor yang pertama menjadi pembimbing selanjut nya asisten ahli"
		},
		{
 			:symbolic=> "aa_first_then_lektor",
  		:description=> "Dosen ber-level asisten ahli yang pertama menjadi pembimbing selanjut nya lektor"
  	},
  	{
  		:symbolic=> "lektor_first_then_free",
  		:description=> "Dosen ber-level lektor yang pertama menjadi pembimbing selanjutnya boleh lektor atau asisten ahli"
  	},
  	{
  		:symbolic=>"aa_first_then_free",
  		:description=>"Dosen ber-level asisten ahli yang pertama menjadi pembimbing selanjutnya boleh lektor atau asisten ahli"
  	},
  	{
  		:symbolic=>"free",
  		:description=>"Dosen ber-level asisten ahli atau lektor pertama menjadi pembimbing selanjutnya boleh lektor atau asisten"
  	}
  ]
end
