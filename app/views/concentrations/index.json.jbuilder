json.array!(@concentrations) do |concentration|
  json.extract! concentration, :id, :name, :description
  json.url concentration_url(concentration, format: :json)
end
