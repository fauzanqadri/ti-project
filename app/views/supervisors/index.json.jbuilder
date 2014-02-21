json.array!(@supervisors) do |supervisor|
  json.extract! supervisor, :id, :course_id, :lecturer_id, :approved
  json.url supervisor_url(supervisor, format: :json)
end
