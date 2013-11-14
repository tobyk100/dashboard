json.array!(@teacher_prizes) do |teacher_prize|
  json.extract! teacher_prize, :prize_provider, :code, :user
  json.url teacher_prize_url(teacher_prize, format: :json)
end
