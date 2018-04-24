FactoryBot.define do
  factory :feed do
    association :user, factory: :user
    
    transient do
      create_twitter_post true
      twitter_posts_count 5
    end
    
    after(:create) do |feed, evaluator|
      if evaluator.create_twitter_post
        build(:twitter_post, feed: feed)
      end
    end
  end
end
