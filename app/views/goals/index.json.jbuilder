json.array!(@goals) do |goal|
  json.extract! goal, 
  json.url goal_url(goal, format: :json)
end
