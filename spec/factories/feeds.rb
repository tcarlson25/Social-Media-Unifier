FactoryBot.define do
  factory :feed do
    association :user, factory: :user
  end
end
