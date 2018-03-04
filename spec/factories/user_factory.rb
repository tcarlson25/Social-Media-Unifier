FactoryBot.define do
    factory :user do
        provider "twitter"
        uid "12345"
        name "Test User"
        profile_image "Test Image"
        token "125787992-RVynw09XMFqT87H114atAZvLoz6jVw4v3pkybhwi"
        secret "5Cq8wiwRApWzDXMAOPYvkCBF2oeejd6hpVFkfFEqv2q0l"
    end
end