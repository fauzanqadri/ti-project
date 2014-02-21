json.array!(@staffs) do |staff|
  json.extract! staff, :id, :full_name, :address, :born, :staff_since
  json.url staff_url(staff, format: :json)
end
