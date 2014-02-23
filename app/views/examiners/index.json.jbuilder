json.array!(@examiners) do |examiner|
  json.extract! examiner, :id, :sidang_id, :lecturer_id
  json.url examiner_url(examiner, format: :json)
end
