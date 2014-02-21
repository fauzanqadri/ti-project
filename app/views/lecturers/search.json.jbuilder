json.array!(@lecturers) do |lecturer|
  json.extract! lecturer, :id, :supervisors_skripsi_count, :supervisors_pkl_count
  json.full_name lecturer.to_s
end
