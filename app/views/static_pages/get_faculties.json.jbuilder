json.array!(@faculties) do |faculty|
  json.extract! faculty, :id, :name
end
