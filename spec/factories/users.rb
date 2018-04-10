FactoryBot.define do
  factory :user do
    
    transient do 
      create_identity true
    end
    
    after(:create) do |user, evaluator|
      create(:feed, user: user)
      if evaluator.create_identity
        create(:identity, user: user)
        create(:identity, provider: "facebook", user: user)
        create(:identity, provider: "mastodon", user: user)
        
      end
    end
  end
end
