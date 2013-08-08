json.array!(@activities) do |activity|
  json.extract! activity, 
  json.url activity_url(activity, format: :json)
end
