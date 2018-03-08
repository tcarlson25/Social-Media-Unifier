FactoryBot.define do
    factory :post do
        provider "Provider"
        user "User"
        content "Text"
        imgurl "Image URL"
        created_at "Time"
        retweet_count "Retweet Count"
        favorite_count "Favorite Count"
    end
end