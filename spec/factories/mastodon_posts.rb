FactoryBot.define do
  factory :mastodon_post do
    id 1
    content "Content"
    username "Username"
    profile_img "ProfileImage"
    imgurls "Urls"
    favourited false
    favourites_count 1
    reblogged false
    reblogs_count 1
  end
end
