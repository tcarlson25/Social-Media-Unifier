FactoryBot.define do
  factory :twitter_post do
    association :feed, factory: :feed, create_twitter_post: false
    content "This is a test twitter post"
    favorite_count "5"
    favorited true
    retweet_count "6"
    retweeted true
    post_made_at "Test Time"
    id "123456789"
  end
end
