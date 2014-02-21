json.array!(@students) do |student|
  json.extract! student, :id, :nim, :full_name, :address, :born, :student_since
  json.url student_url(student, format: :json)
end
