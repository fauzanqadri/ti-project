json.array!(@settings) do |setting|
  json.extract! setting, :id, :supervisor_skripsi_amount, :supervisor_pkl_amount, :examiner_amount, :maximum_lecturer_lektor_skripsi_lead, :maximum_lecturer_aa_skripsi_lead, :allow_remove_supervisor_duration, :lecturer_lead_skripsi_rule, :lecturer_lead_pkl_rule, :allow_student_create_pkl, :department_id
  json.url setting_url(setting, format: :json)
end
