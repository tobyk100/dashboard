json.array!(@providers) do |provider|
  json.extract! provider, :name
  json.url provider_url(provider, format: :json)
end
