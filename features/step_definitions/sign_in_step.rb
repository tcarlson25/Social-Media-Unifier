Given("The user is not signed in") do
   @user = nil 
end

When("The user clicks Sign in to Twitter") do
    @user = create(:user)
    twitter_posts = [TwitterPost.new({
      :content => 'Content',
      :favorite_count => '1',
      :retweet_count => '2'
    })]
    allow(@feed).to receive(:twitter_posts).and_return(twitter_posts)
    visit 'sign_in'
    click_link "Sign in with Twitter"
end

Then("The user should be populated") do
    expect(@user).to be_an_instance_of(User)
end

Then("They should see an error saying {string}") do | error |
    expect(page).to have_content(error)
end

Given("The user is signed in") do
  @user = create(:user)
  twitter_posts = [TwitterPost.new({
      :content => 'Content',
      :favorite_count => '1',
      :retweet_count => '2'
  })]
  allow(@feed).to receive(:twitter_posts).and_return(twitter_posts)
  visit 'users/sign_in'
  click_link "Sign in with Twitter"
end