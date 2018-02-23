Given("The user is on the home page") do
  visit '/feed/index'
end

When("They click on Account Settings") do
  click_on "Account Settings"
end

Then("They should be redirected to the Account Settings page") do
  expect(page).to have_content("Account Settings")
end