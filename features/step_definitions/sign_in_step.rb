Given("The user is not signed in") do
   @user = nil 
end

When("The user clicks Sign in to Twitter") do
    @user = create(:user)
    visit '/auth/:twitter/callback'
end

Then("The user should be populated") do
    expect(@user).to be_an_instance_of(User)
end

Then("They should see an error saying {string}") do | error |
    expect(page).to have_content(error)
end