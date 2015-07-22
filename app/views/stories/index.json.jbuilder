json.array!(@stories) do |story|
  json.extract! story, :id, :title, :rating, :text
  json.url story_url(story, format: :json)
end
