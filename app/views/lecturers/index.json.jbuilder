json.array!(@lecturers) do |lecturer|
  json.extract! lecturer, :id, :nip, :nid, :full_name, :address, :born, :level, :front_title, :back_title
  json.url lecturer_url(lecturer, format: :json)
end
