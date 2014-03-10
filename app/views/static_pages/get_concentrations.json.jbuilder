json.array!(@concentrations) do |concentration|
  json.extract! concentration, :id, :name
end
