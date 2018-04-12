FactoryBot.define do
  factory :mastodon_post do
    id 1
    content "MyString"
    username "MyString"
    profile_img "MyString"
    imgurl "MyString"
    favourited false
    favourites_count 1
    reblogged false
    reblogged_count 1
  end
end
