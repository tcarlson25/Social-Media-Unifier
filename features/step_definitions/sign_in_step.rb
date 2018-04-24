Given("The user is not signed in") do
   @user = nil 
end

Given("The user is not signed in to {string}") do |provider|
   OmniAuth.config.mock_auth[:twitter] = nil if provider.eql?('Twitter')
   OmniAuth.config.mock_auth[:facebook] = nil if provider.eql?('Facebook')
end

Given("The user is signed in and using {string}") do |provider|
    visit 'users/sign_in'
    click_link "Sign in with Google"
    visit(settings_accounts_path)
    if provider.eql?('Twitter')
        page.find('.card-twitter').click
        click_button 'signin_twitter' 
    end
    click_button 'signin_facebook' if provider.eql?('Facebook')
end

Given("The user is signed into {string}") do |provider|
    click_button 'signin_twitter' if provider.eql?('Twitter')
    click_button 'signin_facebook' if provider.eql?('Facebook')
end

When("The user signs in to {string}") do |provider|
    click_button 'signin_twitter' if provider.eql?('Twitter')
    click_button 'signin_facebook' if provider.eql?('Facebook')
end

When("The user signs out of {string}") do |provider|
    visit(settings_accounts_path)
    click_button "signout_twitter" if provider.eql?('Twitter') 
end

When("The user clicks Sign in to {string}") do |provider|
    return_posts = []
    allow_any_instance_of(FeedsController).to receive(:get_tweets).and_return(return_posts)
    click_link "Sign in with Google" if provider.eql?('Google')
end

Then("The user should be populated") do
    expect(@user).to be_an_instance_of(User)
end

Then("They should see an error saying {string}") do | error |
    expect(page).to have_content(error)
end


Then("The user should have access to {string}") do |provider|
    expect(current_user.twitter).to not_be(nil) if provider.eql?('Twitter') 
end