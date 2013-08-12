FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "testuser#{n}" }
    email { "#{username}@example.com" }
    password "00secret"

    # Child of :user factory, since it's in the `factory :user` block
    factory :admin do
      admin true
    end
  end

  factory :game do
    sequence(:name) { |n| "game#{n}.com"}
  end

  factory :level do
    sequence(:name) { |n| "Level #{n}" }
    level_url "http://espn.com"
    game
  end

  factory :activity do
    level
    user
  end
end