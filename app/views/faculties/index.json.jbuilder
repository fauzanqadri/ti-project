json.array!(@faculties) do |faculty|
  json.extract! faculty, :id, :name, :description, :website
  json.url faculty_url(faculty, format: :json)
end
