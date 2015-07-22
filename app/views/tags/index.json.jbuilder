json.array!(@tags) do |tag|
  json.extract! tag, :id, :short, :full
  json.url tag_url(tag, format: :json)
end
