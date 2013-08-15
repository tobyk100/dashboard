FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "testuser#{n}" }
    email { "#{username}@example.com" }
    password "00secret"
    language 'en'

    # Child of :user factory, since it's in the `factory :user` block
    factory :admin do
      admin true
    end
  end

  factory :game do
    sequence(:name) { |n| "game#{n}.com"}
    base_url 'http://gameurl.bogus/puzzle'
  end

  factory :level do
    sequence(:name) { |n| "Level #{n}" }
    #level_url "http://espn.com"
    level_num 3
    game
  end

  factory :activity do
    level
    user
  end

  factory :concept do
    sequence(:name) { |n| "Algorithm #{n}" }
    description 'Bogus text'
  end
end