Given("The user is not signed in") do
   @user = nil 
end

Given("The user is not signed in to {string}") do |provider|
   OmniAuth.config.mock_auth[:twitter] = nil if provider.eql?('Twitter')
   OmniAuth.config.mock_auth[:facebook] = nil if provider.eql?('Facebook')
end

When("The user clicks Sign in to {string}") do |provider|
    click_link "Sign in with Facebook" if provider.eql?('Facebook')
    click_link "Sign in with Twitter" if provider.eql?('Twitter')
end

Then("The user should be populated") do
    expect(@user).to be_an_instance_of(User)
end

Then("They should see an error saying {string}") do | error |
    expect(page).to have_content(error)
end

Given("The user is signed in") do
  #@feed = Feed.new({
  #    :user_id => @user.id
  #})
  #twitter_posts = [TwitterPost.new({
  #    :content => 'Content',
  #    :favorite_count => '1',
  #    :retweet_count => '2'
  #})]
  #allow(@feed).to receive(:twitter_posts).and_return(twitter_posts)
  visit 'users/sign_in'
  click_link "Sign in with Twitter"
end

Given("The user is signed in to {string}") do |provider|
   visit 'users/sign_in'
   click_link "Sign in with Twitter" if provider.eql?('Twitter')
   click_link "Sign in with Twitter" if provider.eql?('Facebook')
end