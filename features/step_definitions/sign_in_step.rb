Given("The user is not signed in") do
   @user = nil 
end

Given("The user is not signed in to {string}") do |provider|
   OmniAuth.config.mock_auth[:twitter] = nil if provider.eql?('Twitter')
   OmniAuth.config.mock_auth[:facebook] = nil if provider.eql?('Facebook')
end

When("The user signs in to {string}") do |provider|
    click_button 'edit_providers'
    click_link "#{provider.downcase}_add"
end

When("The user logs out of {string}") do |provider|
   click_link "#{provider.downcase}_remove" 
end

When("The user clicks Sign in to {string}") do |provider|
    return_posts = []
    allow_any_instance_of(FeedsController).to receive(:get_tweets).and_return(return_posts)
    click_link "Sign in with Facebook" if provider.eql?('Facebook')
end

Then("The user should be populated") do
    expect(@user).to be_an_instance_of(User)
end

Then("They should see an error saying {string}") do | error |
    expect(page).to have_content(error)
end

Given("The user is signed in") do
    return_posts = []
    test_user = Koala::Facebook::TestUsers.new(app_id: ENV['FACEBOOK_APP_ID'], secret: ENV['FACEBOOK_SECRET'])
    allow_any_instance_of(User).to receive(:facebook_client).and_return(test_user)
    allow_any_instance_of(FeedsController).to receive(:get_tweets).and_return(return_posts)
    visit 'users/sign_in'
    click_link "Sign in with Facebook"
end

# Given("The user is signed in to {string}") do |provider|
#     return_posts = []
#     allow_any_instance_of(FeedsController).to receive(:get_tweets).and_return(return_posts)
#     visit 'users/sign_in'
#     click_link "Sign in with Twitter" if provider.eql?('Twitter')
#     click_link "Sign in with Facebook" if provider.eql?('Facebook')
# end