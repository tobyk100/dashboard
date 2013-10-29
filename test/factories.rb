FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "testuser#{n}" }
    email { "#{username}@example.com" }
    password "00secret"
    locale 'en-US'
    name { "#{username} Codeberg" }

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
  end

  factory :video do
    sequence(:name) { |n| "Intro to Concept#{n}" }
    key { "#{name.underscore}" }
    youtube_code 'Bogus text'
  end
end