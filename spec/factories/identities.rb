FactoryBot.define do
  factory :identity do
    association :user, factory: :user, create_identity: false
    provider "twitter"
    uid "UID"
    token "Test Token"
    secret "Test Secret"
    name "Test Name"
    email "Test Email"
  end
end
