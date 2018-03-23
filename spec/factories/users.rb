FactoryBot.define do
  factory :user do
    provider "Twitter"
    uid "uid"
    email "email"
    password "password"
    name "Name"
  end
end
