FactoryBot.define do
  factory :user do
    
    transient do 
      create_identity true
    end
    
    after(:create) do |user, evaluator|
      create(:feed, user: user)
      if evaluator.create_identity
        create(:identity, user: user)
        create(:facebook_identity, user: user)
        create(:mastodon_identity, user: user)
        
      end
    end
  end
end
