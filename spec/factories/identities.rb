FactoryBot.define do
  factory :identity do
    association :user, factory: :user, create_identity: false
    
    provider "twitter"
    uid "UID"
    token "125787992-pHZADYAQKenEC9SbVcoiJRiNJYhaM41AnGCEZUC9"
    secret "awRnIa0450TgSF5Ol9cFCCrDflYSOihe8499iJmWKeIkq"
    name "Test Name"
    email "Test Email"
  end
  
  factory :facebook_identity, parent: :identity do
    provider "facebook"
    uid "UID"
    token "EAACBXgq1zpQBADx4kowWfZCWJfqd8gislm1ZAOqwvC4BTtXNgIpGrJ5jyrXOQ0beZBANetZB8D7H06MoMMenQnNJvemqq0ZA15tndtDCQ9C0gIkjZBIFml5qaZBxIKIZAnH2vD9cZC2QanH81tb6wcisFoZCiO8q75ZC5BpAvwHamVHQgZDZD"
    secret "Secret"
    name "Test Name"
    email "Test Email"
  end
  
  factory :mastodon_identity, parent: :identity do
    provider "mastodon"
    uid "UID"
    token "43746cd35103b829b9e7d6e6c81235723ac53f3c965ab3f467ebc01655e3d1bb"
    secret "Secret"
    name "Test Name"
    email "Test Email"
  end
end
