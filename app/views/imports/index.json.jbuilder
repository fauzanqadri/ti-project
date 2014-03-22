json.array!(@imports) do |import|
  json.extract! import, :id, :klass_action
  json.url import_url(import, format: :json)
end
