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

  factory :provider do
    sequence(:name) { |n| "provider#{n}.com"}
  end

  factory :goal do
    sequence(:name) { |n| "Goal #{n}" }
    sequence(:token) { |n| "goal_#{n}" }
    goal_type "time"
    provider
  end

  factory :activity do
    goal
    user
  end
end