json.array!(@conferences) do |conference|
  json.extract! conference, :id, :local, :start, :end
  json.url conference_url(conference, format: :json)
end
